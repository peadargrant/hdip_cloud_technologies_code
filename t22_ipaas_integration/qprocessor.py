# Simple Python SQS queue processor
# Peadar Grant

# Aim:
# Receive SQS message and put it into S3

import sys
import uuid
from argparse import ArgumentParser

# must install boto3 to use this (pip3 install boto3)
import boto3

# get QueueUrl + Bucket Name from command line  
parser = ArgumentParser()
parser.add_argument('--queue-url', help='Queue URL', required=True)
parser.add_argument('--bucket-name', help='Bucket name', required=True)
args = parser.parse_args()
    
queue_url=args.queue_url
bucket_name=args.bucket_name

# client object for SQS
sqs = boto3.client('sqs')

# client object for S3
s3 = boto3.client('s3')

wait_time_seconds = 1

while True:
    # receive
    response = sqs.receive_message(QueueUrl=queue_url, WaitTimeSeconds=wait_time_seconds, MaxNumberOfMessages=1)
    wait_time_seconds = 20

    if 'Messages' not in response:
        print('no messages')
        continue

    # loop over all messages
    for message in response['Messages']:
        
        # do processing work here (example just prints)
        print("received: " + message['Body'])
        
        # save message to s3
        s3.put_object(
            Bucket=bucket_name,
            Body=message['Body'],
            Key='%s.txt' % uuid.uuid1()
    )
        
        # delete once processed
        sqs.delete_message(QueueUrl=queue_url, ReceiptHandle=message['ReceiptHandle'])
        
    
