date
uname -n
uptime
cat /etc/redhat-release
# Version 1.20

echo -e "\n********** Start Health Check for server $(uname -n) at $(date)"

#### Memory, CPU and Processes
echo -e "\n\n#### Memory, CPU and Processes\n"
echo -e "## uptime command output"
uptime; echo
echo -e "\n## free -m command output"
free -m; echo
# Check for Zombie Processes
echo -e "\n## Check for Zombie processes using ps command output"
ps -eo state,pid,user,cmd | egrep "^Z"
echo -e "\n## vmstat -S m 1 5 command output"
vmstat -S m 1 5; echo
echo -e "\n## top -b -n 1 | head -n 20 command output"
top -b -n 1 | head -n 20; echo
echo -e "\n## pstree command output"
pstree; echo

#### Disks and File Systems Checks
echo -e "\n\n#### File Systems Checks\n"
# Check = Detect Read Only mounted file systems
echo -e "\n## Read Only File System Checks output"
if grep ' ro,' /proc/mounts; then
    echo -e"\n********* ERROR - Read Only File System Found"
else
    echo -e"\n********* No Read Only File Systems Found"
fi
echo -e "\n## df -h command output"
df -h; echo
echo -e "\n## mount command output"
mount; echo
echo -e "\n## lsblk command output"
lsblk; echo
echo -e "\n## vgdisplay command output"
vgdisplay -v 2>&1; echo

# Add iostat command

#### Network Systems Check
echo -e "\n\n#### Network Systems Check\n"
# Network Interface Check
ip addr; echo
# IP Route Check
ip route; echo
# NTP Check
ntpq -pn; echo
# DNS Check
dig $(uname -n); echo
# Add dig -x DNSREOVLER1
# Add mtr command to DNS and NTP servers
# Add Network stats checks, use netstat, ss

#### Log Files Checks
echo -e "\n\n#### Log Files Checks\n"
ls -lth /var/log/messages*
if ! grep -i error /var/log/messages; then
    echo -e "\n**** NO ERRORS FOUND IN /var/log/messages"
fi

# Add run logwatch if installed
# Add run sosreport health checks if inistalled.