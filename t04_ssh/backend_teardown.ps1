#!/usr/bin/env pwsh

$StackName='sshlabbackend'

aws cloudformation delete-stack --stack-name $StackName

Write-Host 'waiting for stack deletion'
aws cloudformation wait stack-delete-complete --stack-name $StackName
Write-Host 'Done!'
