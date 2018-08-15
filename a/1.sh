#!/bin/bash


HOSTNAME="localhost"
PORT="3306"
USERNAME="root"
PASSWORD="password"
DBname=ww_f14
MYSQL=/usr/bin/mysql

echo "use ww_f14;" > test.sql



for user in `cat demo.lst|cut -d, -f9`
do
	student_id=`cat demo.lst|cut -d, -f1`
	last_name=`cat demo.lst|cut -d, -f2`
	first_name=`cat demo.lst|cut -d, -f3`
	status=`cat demo.lst|cut -d, -f4`
	section=`cat demo.lst|cut -d, -f6`
	recitation=`cat demo.lst|cut -d, -f7`

echo $student_id, $last_name, $first_name, $status, $section, $recitation












	echo "select count(*) from STAB27H3_user where user_id='$user';" >> test.sql
	count=`($MYSQL -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} < test.sql|sort|head -n1);`
	count=$( /usr/bin/mysql -hlocalhost -p3306 -uroot -ppassword < test.sql|sort|head -n1);
	if [ $count -eq 1 ]; then
		echo $user is valid
	else
		echo $user is not there
		$MYSQL -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} < EOF
		INSERT INTO TABLE (user_id, first_name, last_name, email_address, student_id, status, recitation, comment) VALUES ($user, $first_name, $last_name, NULL, $student_id, $status, $section, $recitation, NULL);
		EOF
	fi

done
$MYSQL -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "FLUSH PRIVILEGES;"

