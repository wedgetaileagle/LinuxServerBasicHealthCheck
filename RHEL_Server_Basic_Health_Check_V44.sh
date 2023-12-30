#!/bin/bash
##### RHEL Server Basic Health Check
### Version 202312221025

# Function to display server details
server_details() {
  echo -e "===== Server Details ====="
  date
  hwclock
  uname -n
  uname -a
  uptime
  cat /etc/redhat-release
  cat /etc/eds-release
  echo ""
}

# Function to check CPU usage
check_cpu() {
  echo -e "\n===== CPU Usage ====="
  top -b -n 1 | grep "Cpu(s)" | awk '{print "CPU Usage: " $2 + $4 "%"}'
  echo ""
  echo -e "\n********** mpstat 1 5"
  mpstat 1 5
}

# Function to check memory usage
check_memory() {
  echo -e "\n===== Memory Usage in MBs ====="
  free -m | grep -i mem | awk '{print "Total: " $2 ", Used: " $3 ", Free: " $4}'
  echo ""
  echo -e "\n********** free -m"
  free -m
  echo -e "\n********** mpstat 1 5"
  vmstat 1 5
}

# Function to check process
check_processes() {
  echo -e "\n===== Process Resource Usage ====="
  echo -e '\n=== Top 10 Processes By %CPU\n'
  ps -eo %cpu,pid,size,user,cmd | grep PID | egrep -v grep
  ps -eo %cpu,pid,size,user,cmd | egrep -v PID | sort -bn -r | awk 'FNR <= 10'
  echo -e '\n=== Top 10 Processes By %MEM\n'
  ps -eo %mem,pid,size,user,cmd | grep PID | egrep -v grep
  ps -eo %mem,pid,size,user,cmd | egrep -v PID | sort -bn -r | awk 'FNR <= 10'
  echo ""
  echo -e '\n=== Zombie Process Check\n'
  echo -e "******** ps -eo stat,pid,ppid,user,comm | grep -i \"^z\""
  ps -eo stat,pid,ppid,user,comm | grep -i "^z"
  echo -e "\n******** ps -ef | grep -i defunct"
  ps -ef | grep -i defunct | grep -v grep
}

# Function to check disk usage
check_disk() {
  echo -e "\n===== File System Free Space =====\n"
  df -h

  echo -e "\n===== File System Free Inodes =====\n"
  df -i
}

# Function to check system load
check_load() {
  echo -e "\n===== System Load ====="
  uptime
  free
  echo ""
}

# Function to check network connectivity
check_network() {
  echo -e "\n===== Network Connectivity ====="
  echo -e "\n==== ip link ===="
  ip link
  echo -e "\n==== ip addr ===="
  ip addr
  echo -e "\n==== ifconfig -a ===="
  ifconfig -a
  echo -e "\n==== ip route ===="
  ip route
  echo -e "\n==== DNS ===="
  dig $(uname -n) 2>&1
  echo -e "\n==== NTP ===="
  if [ -f /usr/sbin/ntpq ]; then
     ntpq -np 2>&1
  fi
  if [ -f /usr/bin/chronyc ]; then
     echo -e "\n********** chronyc tracking"
     chronyc tracking 2>&1
     echo -e "\n********** chronyc sourcestats"
     chronyc sourcestats 2>&1
     echo -e "\n********** chronyc sources"
     chronyc sources 2>&1
  fi
  echo -e "\n==== ss -tlp ===="
  ss -tlp 2>&1
  echo -e "\n==== ss -tnp ===="
  ss -tnp 2>&1
}

# Main function
main() {
  echo -e "===== RHEL Server Basic Health Check =====\n"

  server_details
  check_cpu
  check_memory
  check_processes
  check_disk
  check_load
  check_network

  echo -e "\n===== End of Health Check ====="
}

# Execute the main function
main