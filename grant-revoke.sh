#!/bin/bash
#==============================================================
#
# Author : ariesrulez2
# Purpose : grant-revoke-user-on multiinstance
# Date : 8/04/2019
#
#======================================================================

User1="DevOps"
sudo useradd $User1
resultuser=`awk -F: '{ print $1}' /etc/passwd | grep "$User1"`
echo $resultuser
if [ "$resultuser" == "$User1" ]; then
echo "user created successfully"
fi
SSH_PUBLIC_KEY=`sudo su "$User1" -c "ssh-keygen -b 4096 -t rsa -f /tmp/id_rsa1 -C '$User1@xyz.com' -q  -N '' ; cat /tmp/id_rsa1.pub" `
# add keys to grant user access
#usermod -a -G wheel $User1

# add the ssh public key
ssh 0.0.0.0 -c "echo $SSH_PUBLIC_KEY >> .ssh/authorised_keys"

