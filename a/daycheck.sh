#!/bin/bash
date=`cat /tmp/val1.txt`
find /home/biosharp/a -type f -name "*$date" > /tmp/val2.txt
if [ `find /home/biosharp/a -name "*$date" | grep '.' || echo $?` -eq 1 ]; then
echo no file found
exit 0
fi



echo you entered $date
#cat /home/biosharp/a/tmp.txt
echo "$date logs"
while read line
do
column $line
done < /tmp/val2.txt



