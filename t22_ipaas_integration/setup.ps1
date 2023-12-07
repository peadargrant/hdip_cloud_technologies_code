#!/usr/bin/env pwsh

$StackName='LAB'

Write-Host 'setting up...'
aws cloudformation create-stack --stack-name $StackName --template-body file://ipaas_template.yaml

Write-Host 'waiting for resources to create... ' -NoNewline
aws cloudformation wait stack-create-complete --stack-name $StackName
Write-Host 'Done!'

