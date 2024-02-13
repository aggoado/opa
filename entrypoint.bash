#!/bin/bash# 

Installing sudo
echo "# Installing sudo"
apt update
apt upgrade
apt install sudo -y

echo "##################################"
echo "####### ENTRYPOINT.bash ##########"
echo "##################################"

# FIX https://stackoverflow.com/questions/50142049/enospc-no-space-left-on-device-nodejs
echo "# fix: no space left on device"
echo 524288 | sudo tee /proc/sys/fs/inotify/max_user_watches
sudo sysctl -p /etc/sysctl.conf
echo "# Max user watches:"
cat /proc/sys/fs/inotify/max_user_watches

# Test Deno
echo "# Testing Deno version"
deno --version

# Start VSCode
echo "# Starting VSCode as $USER"
echo "Current user: $(whoami)"
echo "# Starting VSCode in headless mode"
sudo -u $USER /usr/bin/code --verbose --user-data-dir /userdata --headless
