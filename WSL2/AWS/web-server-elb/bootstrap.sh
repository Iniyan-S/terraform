#!/bin/bash
mkdir /myapp
yum update -y 
yum install httpd -y
aws s3 cp s3://terraform-ec2-bucket/myconf/httpd.conf /etc/httpd/conf/
systemctl start httpd
systemctl enable httpd
INTERFACE=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNETID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE}/subnet-id)
echo '<center><h1>This instance is in the subnet wih ID: SUBNETID </h1></center>' > /myapp/index.txt
sed "s/SUBNETID/$SUBNETID/" /myapp/index.txt > /myapp/index.html

