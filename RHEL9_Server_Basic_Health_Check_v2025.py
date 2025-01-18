#!/usr/bin/python

##### RHELv9 Server Health Check Using Python 3
### Version 202408291417

import os
import subprocess
from datetime import timedelta
def check_os_version():
    return os.popen('cat /etc/redhat-release').read().strip()

def check_uptime():
    with open('/proc/uptime', 'r') as f:
        uptime_seconds = float(f.readline().split()[0])
        uptime_string = str(timedelta(seconds=uptime_seconds))
    return uptime_string

def check_ram():
    with open('/proc/meminfo', 'r') as f:
        meminfo = f.read()
    return meminfo

def check_virtual_memory():
    with open('/proc/swaps', 'r') as f:
        swapinfo = f.read()
    return swapinfo

def check_network_interfaces():
    interfaces = os.listdir('/sys/class/net/')
    return interfaces

def check_dns():
    with open('/etc/resolv.conf', 'r') as f:
        dns_info = f.read()
    return dns_info

def check_ntp():
    ntp_status = subprocess.run(['timedatectl', 'status'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    return ntp_status

def check_file_system_free_space():
    partitions = os.popen('df -h').read()
    return partitions

if __name__ == "__main__":
    print("OS Version:", check_os_version())
    print("Uptime:", check_uptime())
    print("RAM Info:", check_ram())
    print("Virtual Memory Info:", check_virtual_memory())
    print("Network Interfaces:", check_network_interfaces())
    print("DNS Configuration:", check_dns())
    print("NTP Status:", check_ntp())
    print("File System Free Space:", check_file_system_free_space())
