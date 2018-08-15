#!/bin/bash
#Files="~/a/Enrolled_Users"
user_id=`cat /tmp/val.txt`
#user_id=$1
cd /home/biosharp/a/Enrolled_Users
for f in `ls /home/biosharp/a/Enrolled_Users`
do
	if [ "$(grep -c "$user_id" $f)" -eq 1 ]; then
		echo $user_id probably enrolled on $f
	break
	else 
		echo $user_id never enrolled
fi
done


