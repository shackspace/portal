#!/bin/sh
cd /mmc

export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/jffs/sbin:/jffs/bin:/jffs/usr/sbin:/jffs/usr/bin:/mmc/sbin:/mmc/bin:/mmc/usr/sbin:/mmc/usr/bin:/opt/sbin:/opt/bin:/opt/usr/sbin:/opt/usr/bin

date >/mmc/lastcronrun.txt

rightnow=`/bin/date`
unixrightnow=`/bin/date +%s`

if [ -f /mmc/transfer2.tar ]
then
 echo "transfer2 New tarfile $rightnow "  >> /mmc/access.log
 rm -rf transfer2
 tar xvf transfer2.tar
 rm transfer2.tar
fi

if [ $unixrightnow -le 1268582418 ]
then
 echo "Time not set"
 exit 
fi

cat /mmc/transfer2/timeline.list | while 
read line
do
 serial=`echo $line | cut -d " " -f 1`
 key=`echo $line | cut -d " " -f 3`
 start=`echo $line | cut -d " " -f 5`
 end=`echo $line | cut -d " " -f 6`

 if [ $start -le $unixrightnow ]
 then
  if [ $unixrightnow -le $end ]
  then
   echo $serial
   echo "command=\"${serial}\",no-X11-forwarding,no-port-forwarding ssh-rsa $key $serial" >>/mmc/transfer2/authorized_keys.open
   echo "command=\"${serial}\",no-X11-forwarding,no-port-forwarding ssh-rsa $key $serial" >>/mmc/transfer2/authorized_keys.close
  fi
 fi

done
     
rm /mmc/close/.ssh/authorized_keys
rm /mmc/open/.ssh/authorized_keys
mv /mmc/transfer2/authorized_keys.open /mmc/open/.ssh/authorized_keys
mv /mmc/transfer2/authorized_keys.close /mmc/close/.ssh/authorized_keys
chmod 600 /mmc/open/.ssh/authorized_keys
chmod 600 /mmc/close/.ssh/authorized_keys
