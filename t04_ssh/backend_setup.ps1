#!/usr/bin/env pwsh

$StackName='sshlabbackend'

aws cloudformation create-stack --stack-name $StackName --template-body file://backend_template.yml

Write-Host 'waiting for stack to complete'
aws cloudformation wait stack-create-complete --stack-name $StackName

Write-Host 'Done!'


