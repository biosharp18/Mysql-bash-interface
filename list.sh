#!/bin/bash

HOSTNAME="localhost"
PORT="####"
USERNAME="####"
PASSWORD="####"
DBname=####
TABLEname=####
MYSQL=####
INPUTFILE=demo.lst
READFILE=test2.txt
TODAY=$(date +%Y-%m-%d)
echo "use $DBname;" > test.sql
name="demo.lst"
   echo "use $DBname;" > test1.sql
   echo "select count(*) from $TABLEname;" >> test1.sql

 lncount=`($MYSQL -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} < test1.sql)`
list=0

while read line
do
    name=$line
	user=`echo $name|cut -d, -f9`
	student_id=`echo $name|cut -d, -f1`
        last_name=`echo $name|cut -d, -f2`
        first_name=`echo $name|cut -d, -f3`
        status=`echo $name|cut -d, -f4`
        section=`echo $name|cut -d, -f6`
        recitation=`echo $name|cut -d, -f7`

	echo $user, $student_id, $last_name, $first_name, $status, $section, $recitation

   echo "select count(*) from $TABLEname where user_id='$user';" >> test.sql
    count=`($MYSQL -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} < test.sql|sort|head -n1);`
#        count=$( /usr/bin/mysql -hlocalhost -p3306 -uroot -ppassword < test.sql|sort|head -n1);
        if [ $count -eq 1 ]; then
                echo $user is already valid
        else
                echo $user is not there, adding $user to database
		echo "use $DBname;" > data.sql
		echo "INSERT INTO $TABLEname (user_id, first_name, last_name, email_address, student_id, status, section, recitation, comment) VALUES ('$user', '$first_name', '$last_name', NULL, '$student_id', '$status', '$section', '$recitation', NULL);" >> data.sql
		let "list++"
                $MYSQL -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} < data.sql
		echo Added $user >> ~/a/Enrolled_Users/Enrolled.$TABLEname.$TODAY
        fi
$MYSQL -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "FLUSH PRIVILEGES;"

done < $INPUTFILE

echo "use $DBname;" > test1.sql
echo "show tables;" >> test1.sql
echo "select user_id from $TABLEname;" >> test1.sql
verify=`($MYSQL -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} < test1.sql)` 
echo $verify | tr ' ' '\n' >  test2.txt 
sed -i '1,79d' test2.txt

while read line    #every userid in database one by one
do
check=0
name=$line
#grep '$name' $INPUTFILE
#	if [ $? -eq 0 ]; then
#		echo $name is good
#	else
#		echo $name maybe dropped

if [ "$(grep -c "$name" $INPUTFILE)" != 1 ]; then   #if userid is not found in input file
		echo "user id not found in $READFILE"
	cd ~/a/Dropped_Users                    #go to dropped users
	for f in `ls ~/a/Dropped_Users`          #scan every file
	do
		check=$((check + `(grep -c "$name" $f)`)) 
	done
		if [ $check -eq 0 ]; then #if no instance of user is found
			 echo "$name not found (and maybe dropped)" >> ~/a/Dropped_Users/Dropped.$TABLEname.$TODAY
		fi

	cd ~/a/
fi
done < $READFILE





echo `cat $INPUTFILE| wc -l` students in list
echo $lncount students in database
echo $list students added



