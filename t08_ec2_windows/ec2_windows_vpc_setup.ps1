#!/usr/bin/env pwsh
# script to setup lab VPC for EC2 Windows lab (uses CloudFormation internally)
# Peadar Grant

$KeyPairName = "MAIN_KEY"
$StackName = "LAB-STACK"

$KeyPairs=(aws ec2 describe-key-pairs --filters Name=key-name,Values=$KeyPairName | ConvertFrom-Json).KeyPairs
if ( $KeyPairs.Count -ne 1 ) {
   throw "must be exactly 1 key pair named $KeyPairName (found $($KeyPairs.Count))."
}
Write-Host "KeyPair: $($KeyPairs[0].KeyPairId)"

$Stacks=(aws cloudformation describe-stacks | ConvertFrom-Json).Stacks
foreach ( $Stack in $Stacks ) {
    if ( $StackName -eq $Stack.StackName ) {
	Write-Host "it looks like you have already run the setup for this or another lab!" -ForegroundColor Yellow
	throw "stack $StackName already exists - setup already done or in progress!"
    }
}

$Vpcs=(aws ec2 describe-vpcs --filter Name=tag:Name,Values=LAB_VPC | ConvertFrom-Json).Vpcs

if ( $Vpcs.Count -ge 1 ) {
    throw "found $($Vpcs.Count) VPCs named LAB_VPC - delete this first before continuing"
}

Write-Host "creating stack of resources ..." -NoNewline
aws cloudformation create-stack --stack-name $StackName --template-body file://ec2_windows_template.yml
Write-Host "ok" -ForegroundColor Green

Write-Host "waiting for stack complation (may take a while) ... " -ForegroundColor Yellow -NoNewline
aws cloudformation wait stack-create-complete
Write-Host "ok" -ForegroundColor Green

Write-Host "Lab environment ready" -ForegroundColor White -BackgroundColor Green 

Write-Host "IMPORTANT!
Remember to terminate instance(s) made during this lab.
Then run the ./ec2_windows_vpc_teardown.ps1 script
(or remove the VPC manually if you want)." -ForegroundColor Yellow

