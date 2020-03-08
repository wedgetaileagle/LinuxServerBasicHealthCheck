#!/bin/bash
# Check if Linux OS is systemd or initv

if [ -f /bin/systemctl ]; then
    echo 'systemd'
else
    echo 'initv'
fi
