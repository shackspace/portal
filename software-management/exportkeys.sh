#!/bin/bash

rm -f authorized_keys users.list timeline.list
rm -rf transfer2
mkdir transfer2

for i in `echo "select serialnumber from user;" |sqlite3 shackspacekey.sql3`
do
 publickey=`echo "select PublicKey from user where serialnumber = $i;" |sqlite3 shackspacekey.sql3`
 name=`echo "select Givenname,Surname from user where serialnumber = $i;" |sqlite3 shackspacekey.sql3`
 fingerprint=`echo "select fingerprint from user where serialnumber = $i;" |sqlite3 shackspacekey.sql3`
 firstdate=`echo "select strftime('%s',FirstValidDate) from user where serialnumber = $i;" |sqlite3 shackspacekey.sql3`
 lastdate=`echo "select strftime('%s',LastValidDate) from user where serialnumber = $i;" |sqlite3 shackspacekey.sql3`
 echo "$i $fingerprint $name"              >> transfer2/users.list
 echo "$i $publickey $firstdate $lastdate" >> transfer2/timeline.list
done 

echo -e "\ntransfer2ing package"
tar cvf transfer2.tar transfer2
scp -qi root.key transfer2.tar root@192.168.1.1:/mmc/

echo -e "\nfetching log"
scp -qi root.key root@192.168.1.1:/tmp/access.log .

cat access.log >> accesslog.log
rm -f access.log

#rm -rf transfer2
#rm -f transfer2.tar

echo -e "\nsetting date and time"
./setdate.sh

echo -e "\nrunning cron"
./runcron.sh
