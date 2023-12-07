# Tasks

1. Use `setup.ps1` to setup EC2 instance, Bucket and Queue.

2. Copy the Queue URL, Bucket name and Instance Public IP to a text file.

3. Create a Role for EC2 instances with Administrator permissions. 

4. Use SFTP to transfer the qprocessor.py to the instance.
   sftp ec2-user@publicip
   put qprocessor.py
   exit

5. Connect to the instance using SSH. 

6. Set region using aws configure [don't enter keys, just hit enter]

7. Try a command like aws ec2 describe-vpcs .

8. Install the boto3 library for python3 by using:
	sudo pip3 install boto3 

6. Run the `qprocessor.py` program so that it's printing "no messages".

7. Send some messages to your queue from your lab desktop - these should be received.
   Also check that they are appearing in the bucket.

8. Stop your `qprocessor.py`. (Ctrl-C)

9. Install the service unit file in `/etc/systemd/system/qprocessor.service`.
	Modify to point to your queue.
	(must use full paths - find full path of any command using 'which')

10. Enable your service (sudo systemctl enable qprocessor)

11. Start your service. (sudo systemctl start qprocessor)

12. Send messages to your queue. Do they appear in the file `qmessages.txt`?

13. Empty bucket:
	aws s3 rm --recursive s3://lab-bucket-m0teja7366ba/