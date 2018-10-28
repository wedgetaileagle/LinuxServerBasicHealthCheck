# LinuxServerBasicHealthCheck
RHEL Linux server basic health check

-------------------------------------------------------------------

#!/bin/bash
#####
## Version = 1.10 ;), so still developing
#####

date
uname -n
cat /etc/redhat-release

#### Memory, CPU and Processes
echo -e "\n\n#### Memory, CPU and Processes\n"
uptime; echo
free -m; echo
top -b -n 1 | head -n 20; echo
pstree; echo
#Check - Process consuming most Virtual Memory
ps -eo 'vsz pid ruser cpu time args' | sort -nr | head -25; echo
## Check - Zombie process
ps -eo stat,pid,user,cmd|grep -w Z|awk '{print $2}'; echo
mpstat 1 10; echo
vmstat 1 10; echo
iostat -c 1 10; echo

#### Disks and File Systems Checks
echo -e "\n\n#### File Systems Checks\n"
df -h; echo
mount; echo
lsblk; echo
vgdisplay -v; echo

#### Network Systems Check
echo -e "\n\n#### Network Systems Check\n"
ip addr; echo
ip route; echo
ntpq -pn; echo
dig $(uname -n); echo

#### Log Files Checks
echo -e "\n\n#### Log Files Checks\n"
ls -lth /var/log/messages*
if ! grep -i error /var/log/messages; then
    echo -e "\n**** NO ERRORS FOUND IN /var/log/messages"
fi

