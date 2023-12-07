#!/usr/bin/env pwsh
# Teardown for IPAAS lab environment

# S3 buckets need to be emptied before cloudformation can delete them!
Write-Host "emptying bucket..."
$BucketName = ((aws cloudformation describe-stacks --stack-name LAB | ConvertFrom-Json).Stacks[0].Outputs | Where-Object OutputKey -eq BucketName).OutputValue
aws s3 rm --recursive s3://$BucketName/

# Delete the stack
Write-Host "deleting stack"
aws cloudformation delete-stack --stack-name LAB

