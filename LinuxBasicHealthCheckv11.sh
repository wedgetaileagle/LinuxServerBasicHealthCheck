#!/bin/bash
#####
# Date: 7/5/2019
# Version: 1.1
# Function: Produce a Redhat Linux Server Check Report report
# - Execute using the root uid
# - Can be run from a collector using ssh-keys to authenticate
# -- or can be executed using the Linux crond scheduler service.
# - 97% of code will run on any Linux distribution.
#####

LGWFN="$(uname -n)_$(date +%Y%M%d%H%m)_Logwatch.out"

date
uname -n
cat /etc/redhat-release

#### Memory, CPU and Processes
echo -e "\n\n#### Memory, CPU and Processes\n"
uptime; echo
free -m; echo

#### Disks and File Systems Checks
echo -e "\n\n#### File Systems Checks\n"
df -h; echo
mount; echo
# Check - FS RO mounted
mount | egrep -iw "ext4|ext3|xfs|gfs|gfs2|btrfs" | sort -u -t' ' -k1,2

#### Network Systems Check
echo -e "\n\n#### Network Systems Check\n"
ip addr; echo
ip route; echo
ntpq -pn; echo
dig $(uname -n); echo
netstat -aln | grep 'LISTEN '; echo

#### Log Files Checks
echo -e "\n\n#### /var/log/messages Log File Error Checks\n"
grep -i 'error' /var/log/messages

#### Run logwatch
echo -e "\n\n#### Run logwatch\n"
#/usr/sbin/logwatch  --detail 'High' --output 'file' --filename "$LGWFN_logwatch.report"
/usr/sbin/logwatch  --detail 'High' > $LGWFN

#### Create sosreport
echo -e "\n\n#### Creating sosreport\n"
/usr/sbin/sosreport --batch
