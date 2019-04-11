#!/bin/bash
#==============================================================
#
# Author : ariesrulez2
# Purpose : grant-revoke-user-on multiinstance
# Date : 11/04/2019
#
#======================================================================

User1="user3"
UserAddSshAcess(){
#Add  user
sudo adduser --force-badname  $User1
#Add user to Dev Group
sudo adduser $User1 Dev
#Check if user added
resultuser=`awk -F: '{ print $1}' /etc/passwd | grep "$User1"`
echo $resultuser
if [ "$resultuser" == "$User1" ]; then
echo "user created successfully"
fi
#enerate public SShkey for user
SSH_PUBLIC_KEY=`sudo su $User1 -c "ssh-keygen -b 4096 -t rsa -f /home/$User1/.ssh/id_rsa -C '$User1@xyz.com' -q  -N '' ; cat /home/$User1/.ssh/id_rsa " `

sudo cat  /home/"$User1"/.ssh/id_rsa > authorized_keys 
#Copy key to admin users authorized key
scp authorized_keys adminuser@$hostname:/home/adminuser
ssh adminuser@$hostname "sudo adduser -m -p 12345 $User1; mkdir /home/$User1/.ssh/ "   
#Move public key to users authorized key file
ssh adminuser@$hostname "sudo mv /home/adminuser/authorized_keys /home/$User1/.ssh/authorized_keys"
#Change owner
ssh adminuser@$hostname "sudo chown $User1:$User1 /home/$User1/.ssh/authorized_keys"


}

UserRevokeSshAcess(){
ssh adminuser@$hostname "sudo cd /home/$User1/; rm ~/.ssh/authorized_keys"

}
#Main Call

#Get VM ips  From txt file
NoOfVms=`cat hostnames.txt| sort | uniq | wc -l`
 echo "Total number of VMS: " $NoOfVms
 for (( i=1; i<=$NoOfVms; i++ ))
   do
    CurrVM=`cat hostnames.txt | head -$i | tail -1`
    echo $CurrVM
     UserAddSshAcess
     UserRevokeSshAcess
 done
   
