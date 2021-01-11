# LinuxServerBasicHealthCheck
- RHEL Linux server basic health check
- Refer to the latest version attached to this repo
- Run using Server Autoamation system such as Ansible
- Run before \ after a change


-------------------------------------------------------------------
date
uname -n
uptime
cat /etc/redhat-release

# Version 1.20 202101121000
SCRPTVERSION='Version 1.20 202101121000'

################# Server Uptime and Last Reboot
function Check_ServerUptimeAndLastReboot {
    echo -e "\n\n#### Server Uptime and Last Reboot\n"
    echo -e "## uptime command output"
    uptime; echo

    echo -e "\n## last reboot command output"
    last -F reboot; echo
}

################# Memory, CPU and Processes
function Check_MemoryCpuProcesses {
    echo -e "\n\n#### Memory, CPU and Processes\n"
    echo -e "\n## free -m command output"
    free -m; echo

    echo -e "\n## swapon -s command output"
    swapon -s; echo

    echo -e "\n## cat /proc/swaps command output"
    cat /proc/swaps; echo

    # Check for Zombie Processes
    echo -e "\n## Check for Zombie processes using ps command output"

    # ps -eo state,pid,user,cmd | egrep "^Z"
    ps -eo pid,ppid,state,cmd ax | awk '$3=="Z"'

    # Check for D State Processes
    echo -e "\n## Check for D State processes using ps command output"

    # ps -eo state,pid,user,cmd | egrep "^D"
    ps -eo pid,ppid,state,cmd ax | awk '$3=="D"'

    echo -e "\n## vmstat -S m 1 5 command output"
    vmstat -S m 1 5; echo

    echo -e "\n## Top 10 processes Resident Set Size Memory Utilisation"
    ps -eo rsz,pid,size,user ax | sort -bn -r | awk 'FNR <= 10'
    # ps -eo rsz,pid,size,user ax | sort -bn -r | awk 'FNR <= 10'

    echo -e "\n## top -b -n 1 | awk 'FNR <= 5' command output"
    top -b -n 1 | awk 'FNR <= 5'
    #top -b -n 1 | head -n 20; echo

    echo -e "\n## Top 10 processes % Memory Utilisation"
    ps -eo %mem,pid,size,user,cmd ax | sort -bn -r | awk 'FNR <= 10'

    echo -e "\n## Top 10 processes % CPU Utilisation"
    ps -eo %cpu,pid,size,user,cmd | sort -bn -r | awk 'FNR <= 10'

    echo -e "\n## % CPU Utilisation - mpstat 2 10"
    mpstat 2 10

    echo -e "\n## Top 10 processes CPU Time Utilisation"
    ps -eo cputime,pid,size,user,cmd | sort -bn -r | awk 'FNR <= 10'

    #echo -e "\n## pstree command output"
    #pstree; echo
} ## END Function Check_MemoryCpuProcesses

################# Disks and File Systems Checks
function Check_DisksFileSystems {
    echo -e "\n\n#### File Systems Checks\n"
    # Check = Detect Read Only mounted file systems

    echo -e "\n## Read Only File System Checks output"
    if grep " ro," /proc/mounts; then
        echo -e "\n********* ERROR - Read Only File System Found"
    else
        echo -e "\n********* No Read Only File Systems Found"
    fi

    echo -e "\n## df -h command output"
    df -h; echo

    echo -e "\n## mount command output"
    mount; echo

    echo -e "\n## lsblk command output"
    if [ -x /usr/bin/lsblk ]; then
        /usr/bin/lsblk; echo
    else
        echo -e "\n********* /usr/bin/lsblk Command NOT Found"
    fi

    echo -e "\n## vgdisplay command output"
    #vgdisplay -v; echo
    vgdisplay -v | awk '/Status/'; echo
    # Add LV and PV checks

    # Add iostat command
    # Add Fibre Channel Checks
}

#### Network Systems Check
function Check_NetworkSystems {
    echo -e "\n\n#### Network Systems Check\n"
    # Network Interface Check

    echo -e "\n## IP Addresses"
    ip addr; echo

    # IP Route Check
    echo -e "\n## IP Routes"
    ip route; echo

    # NTP Checks
    echo -e "\n## NTP Checks ntpq -pn"
    ntpq -pn; echo

    echo -e "\n## NTP Checks ntpstat"
    ntpstat; echo

    echo -e "\n## NTP Checks ntptime"
    ntptime; echo

    # DNS Check
    echo -e "\n## DNS Checks"
    echo -e "\n## /etc/resolv.conf file"
    cat /etc/resolv.conf; echo

    echo -e "\n## dig hostname"
    dig $(uname -n); echo
    # Add dig -x DNSRESOVLER1
    # Add mtr command to DNS and NTP servers
    # Add Network stats checks, use netstat, ss -l

    # Add iptables firewall check
    echo -e "\n## iptables -L"
    iptables -L; echo
}

#### Log Files Checks
function Check_LogFiles {
    echo -e "\n\n#### Log Files Checks\n"
    ls -lth /var/log/messages*
    if ! egrep -i "error|failed|unable|timeout|fault" /var/log/messages; then
        echo -e "\n**** NO ERRORS FOUND IN /var/log/messages"
    fi
}

###### MAIN

echo -e "\n********** Start Health Check for server $(uname -n) at $(date)"
echo -e "**** Script Version = $SCRPTVERSION"

Check_ServerUptimeAndLastReboot 2>&1
Check_MemoryCpuProcesses 2>&1
Check_DisksFileSystems 2>&1
Check_NetworkSystems 2>&1
Check_LogFiles 2>&1

###### END

# Add run logwatch if installed
# Add run sosreport health checks if inistalled.
# Add SElinux Checks
# Add Docker Checks
