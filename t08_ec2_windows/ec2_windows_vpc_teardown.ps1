#!/usr/bin/env pwsh
# script to tear down VPC for EC2 Windows lab (uses CloudFormation internally)
# Peadar Grant

$StackName="LAB-STACK"

# check that the stack exists
$Stacks=(aws cloudformation describe-stacks | ConvertFrom-Json).Stacks
$doesNotExist=$True
foreach ( $Stack in $Stacks ) {
    if ( $StackName -eq $Stack.StackName ) {
	$doesNotExist=$False
	break
    }
}

if ($doesNotExist) {
    throw "you haven't setup the stack of resources for this lab"
}

# check for running instances
$Stack=(aws cloudformation describe-stacks --stack-name LAB-STACK | ConvertFrom-Json).Stacks[0]

$VpcId=($Stack.Outputs | Where-Object -Property OutputKey -eq VpcId).OutputValue
Write-Host "VpcId: $VpcId"

$Instances = (aws ec2 describe-instances --filters Name=vpc-id,Values=$VpcId | ConvertFrom-Json).Reservations[0].Instances
foreach ( $Instance in $Instances ) {
    if ( "running" -eq $Instances.State.Name ) {
	Write-Host "Instance $($Instance.InstanceId) still running - terminate, wait a few minutes and re-try this script" -ForegroundColor Yellow
	throw "instance still running"
    }
}

# do the delete otherwise
Write-Host "Deleting stack..." 
aws cloudformation delete-stack --stack-name $StackName 
Write-Host "Done!" -ForegroundColor Green

