#!/bin/bash
date
uname -n
uptime
cat /etc/redhat-release

# Version 1.90 202004291240
SCRPTVERSION='Version 1.90 202004291240'

################# Memory, CPU and Processes
function Check_MemoryCpuProcesses {
    echo -e "\n\n#### Memory, CPU and Processes\n"
    echo -e "## uptime command output"
    uptime; echo

    echo -e "\n## free -m command output"
    free -m; echo

    # Check for Zombie Processes
    echo -e "\n## Check for Zombie processes using ps command output"

    # ps -eo state,pid,user,cmd | egrep "^Z"
    ps -eo pid,ppid,state,cmd | awk '$3=="Z"'

    echo -e "\n## vmstat -S m 1 5 command output"
    vmstat -S m 1 5; echo

    echo -e "\n## Top 10 processes Resident Set Size Memory Utilisation"
    ps -eo rsz,pid,size,user | sort -r | awk 'FNR <= 10'
    # ps -eo rsz,pid,size,user,cmd | sort -r | awk 'FNR <= 10' 

    echo -e "\n## top -b -n 1 | awk 'FNR <= 5' command output"
    top -b -n 1 | awk 'FNR <= 5'
    #top -b -n 1 | head -n 20; echo

    echo -e "\n## Top 10 processes % Memory Utilisation"
    ps -eo %mem,pid,size,user,cmd | sort -r | awk 'FNR <= 10'

    echo -e "\n## Top 10 processes % CPU Utilisation"
    ps -eo %cpu,pid,size,user,cmd | sort -r | awk 'FNR <= 10'

    echo -e "\n## Top 10 processes CPU Time Utilisation"
    ps -eo cputime,pid,size,user,cmd | sort -r | awk 'FNR <= 10'

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

    # NTP Check
    echo -e "\n## NTP Checks"
    ntpq -pn; echo

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
    if ! grep -i error /var/log/messages; then
        echo -e "\n**** NO ERRORS FOUND IN /var/log/messages"
    fi
}

###### MAIN

echo -e "\n********** Start Health Check for server $(uname -n) at $(date)"
echo -e "**** Script Version = $SCRPTVERSION"

Check_MemoryCpuProcesses 2>&1
Check_DisksFileSystems 2>&1
Check_NetworkSystems 2>&1
Check_LogFiles 2>&1

###### END

# Add run logwatch if installed
# Add run sosreport health checks if inistalled.
# Add SElinux Checks
