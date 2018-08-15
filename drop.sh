#!/bin/bash
#Files="~/a/Dropped_Users"
cd /home/biosharp/a/Dropped_Users
user_id=`cat /tmp/val.txt`
#user_id="${user_id//[$'\t\r\n']}"
#user_id=$1
for f in `ls /home/biosharp/a/Dropped_Users`
do
	if [ "$(grep -c "$user_id" $f)" -eq 1 ]; then
		echo $user_id probably dropped on $f
	break

fi

done
