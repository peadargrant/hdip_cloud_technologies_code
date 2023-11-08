#!/usr/bin/env pwsh
# script to check lab VPC environment for VPC lab
# Peadar Grant

$CorrectVPCName='LAB_VPC'
$CorrectVPCCIDRBlock="10.0.0.0/16"
$CorrectSubnetCIDRBlock="10.0.1.0/24"

$Vpcs=(aws ec2 describe-vpcs --filter Name=tag:Name,Values=$CorrectVPCName | ConvertFrom-Json).Vpcs

if ( $Vpcs.Count -lt 1 ) {
    throw "no VPC named $CorrectVPCName found"
}

if ( $Vpcs.Count -gt 1 ) {
    throw "found $($Vpcs.Count) VPCs named $CorrectVPCName - rename/delete so 1 left"
}

Write-Host "Found $CorrectVPCName"
$Vpc=$Vpcs[0]

Write-Host "VpcId $($Vpc.VpcId)"

if ( $Vpc.CidrBlock -eq $CorrectVPCCIDRBlock ) {
    Write-Host "CIDR block correct";
}
else {
    throw "CIDR block for VPC $($Vpc.CidrBlock) is incorrect (should be $CorrectVPCCIDRBlock)";
}

# confirm only one subnet in VPC
$CorrectNumberOfSubnets=1
$Subnets=(aws ec2 describe-subnets --filter Name=vpc-id,Values=$($Vpc.VpcId)  --filter Name=tag:Name | ConvertFrom-Json).Subnets
if ( $Subnets.Count -gt $CorrectNumberOfSubnets ) {
    throw "multiple subnets found in VPC - there should be exactly $CorrectNumberOfSubnets"
}

# confirm subnet with right name exists
$CorrectSubnetName='LAB_SUBNET_1'
$Subnets=(aws ec2 describe-subnets --filter Name=vpc-id,Values=$($Vpc.VpcId)  --filter Name=tag:Name,Values=$CorrectSubnetName | ConvertFrom-Json).Subnets
if ( $Subnets.Count -lt 1 ) {
    throw "no subnets in $CorrectVPCName named $CorrectSubnetName found - check names"
}

$Subnet=$Subnets[0]
Write-Host "Subnet $($Subnet.SubnetId)";

# check CIDR block
if ( $Subnet.CidrBlock -eq $CorrectSubnetCIDRBlock ) {
    Write-Host "CIDR block correct";
}
else {
    throw "CIDR block for Subnet $($Subnet.CidrBlock) incorrect (should be $CorrectSubnetCIDRBlock)";
}

# Internet Gateway check
$CorrectInternetGatewayName="LAB_GATEWAY"
$IGWs=(aws ec2 describe-internet-gateways --filter Name=attachment.vpc-id,Values=$($Vpc.VpcId)  --filter Name=tag:Name,Values=$CorrectInternetGatewayName | ConvertFrom-Json).InternetGateways
if ( $IGWs.Count -ne 1 ) {
    throw "$($IGWs.Count) Internet Gateways named $CorrectInternetGatewayName found (should be 1)"
}

# Assume the only internet gateway
$IGW=$IGWS[0];
Write-Host "Gateway $($IGW.InternetGatewayId)";

# Check if IGW attached to VPC 
if ( $IGW.Attachments.Count -eq 1 ) {
    Write-Host "internet gateway attached to VPC"
}
else {
    throw "internet gateway not attached to VPC - attach and try again"
}

# Route Table
$RTBs=(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$($Vpc.VpcId) | ConvertFrom-Json).RouteTables
if ( $RTBs.Count -gt 1 ) {
    throw "$($RTBs.Count) route tables found for VPC - should be 1"
}
if ( $RTBs.Count -lt 1 ) {
    throw "no route table found";
}

# Select the main route table
$RTB=$RTBs[0]
Write-Host "RTB $($RTB.RouteTableId)";

# Check for the internal and external routes
$internalRouteOk=$False
$externalRouteOk=$False
ForEach ( $Route in $RTB.Routes ) {
    if ( $Route.DestinationCidrBlock -eq $CorrectVPCCIDRBlock ) {
        Write-Host 'found internal route';
        $internalRouteOk=$True
    } 
    if ( $Route.DestinationCidrBlock -eq '0.0.0.0/0' ) {
        Write-Host 'found external route';
        if ( $Route.GatewayId -eq $IGW.InternetGatewayId ) {
            Write-Host 'external traffic routed to IGW'
            $externalRouteOk=$True
        }
    }
}
if ($False -eq $internalRouteOk) {
    throw 'internal routing is incorrect - check route table'
}
if ($False -eq $externalRouteOk) {
    throw 'external routing is incorrect - check route table'
}

# Check for security group
$CorrectSGName='LAB_SG'
$SecurityGroups=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=$($Vpc.VpcId) Name=group-name,Values=$CorrectSGName | ConvertFrom-Json).SecurityGroups
if ( $SecurityGroups.Count -ne 1 ) {
    throw "must be 1 security group named $CorrectSGName in $CorrectVPCName $($Vpc.VpcId)"
}
$SecurityGroup=$SecurityGroups[0]
Write-Host "Security group ID $($SecurityGroup.GroupId)"

# Loop through permissions
$ingressRuleOk = $False
ForEach ( $Rule in $SecurityGroup.IpPermissions ) {
    if ( ( $Rule.IpProtocol -eq "tcp" ) -and ( $Rule.ToPort -eq "3389" ) ) {
	Write-Host "found security group rule"
	$IngressRuleOk=$True
    }
}
if ( $IngressRuleOk -eq $False ) {
    throw "check security group ingress rules"
}


Write-Host 'VPC configuration looks OK' -ForegroundColor Green

