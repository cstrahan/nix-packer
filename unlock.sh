#!/bin/bash

# Because sometimes Virtualbox goes crazy...

rm -rf "$HOME/VirtualBox VMs/packer-virtualbox-iso"
rm -rf ./output-virtualbox-iso
PID=`ps aux | grep '[p]acker-virtualbox-iso' | awk '{ print $2 }'`
if [ ! -z "$PID" ]; then
  kill $PID
fi
