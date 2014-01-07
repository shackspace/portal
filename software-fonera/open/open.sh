#!/bin/sh

trap "rm /tmp/portal.lock" EXIT                                                 

# Check for lockfile
if [ -f /tmp/portal.lock ]
 then
  otherpid=`cat /tmp/portal.lock`
  while [ -e /proc/${otherpid} ]
   do
    sleep 1
   done
  rm -f /tmp/portal.lock
fi

echo $$> /tmp/portal.lock 

rightnow=`date`

echo -ne "\n\nSDC 0\n" >/dev/ttyS0 

echo "OPEN $rightnow ${1} ${2}" >> /tmp/access.log

