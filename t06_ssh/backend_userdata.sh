#!/bin/bash
cd /home/ec2-user
yum -y update
adduser student
echo "1password" | passwd student --stdin



