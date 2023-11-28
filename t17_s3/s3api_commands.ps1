# Commands for S3 using S3API
# Peadar Grant
exit # (not for running as script)

$BucketName # is the name of our bucket

# creating a bucket
aws s3api create-bucket --bucket $BucketName  --region eu-west-1  --create-bucket-configuration LocationConstraint=eu-west-1
# Remember bucket names must be globally unique across all AWS users and accounts.

# listing all buckets
aws s3api list-buckets

# PUT a file into S3
# An object (file) is placed into a specified S3 bucket identified by a key (file name).
aws s3api put-object --bucket $BucketName  --key agenda.txt  --body 2020_12_04_agenda.txt
# key = the name S3 will use for object 
# body = the file name on your local system

# Listing bucket contents
aws s3api list-objects --bucket $BucketName

# GETting a file from S3
# An object is requested from a specified S3 bucket identified by a key.
aws s3api get-object  --bucket $BucketName  --key agenda.txt agendadl.txt
# key = name S3 uses for object
# Note: output file name has no parameter switch
# info prints to terminal, file gets saved
# Command will return error if file doesn't exist.

# DELETEing a file
# The object with specified key in specified bucket is deleted.
aws s3api delete-object  --bucket $BucketName  --key agenda.txt
# The delete-object operation is idempotent and returns nothing.

# DELETEing a bucket
aws s3api delete-bucket --bucket $BucketName
# MUST BE EMPTY!
