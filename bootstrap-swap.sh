#!/bin/bash
export PATH=/sbin:/bin:/usr/sbin:/usr/bin

set -e
set -x

if ! $(df -T | grep -q /dev/nvme0n1); then
  mkfs.xfs -f /dev/nvme0n1
  mount -o nodev,noatime,inode64,allocsize=16m /dev/nvme0n1 /gpdb
  dd if=/dev/zero of=/dm-2 count=32768 bs=1MiB
  chmod 600 /dm-2
  mkswap /dm-2
  swapon -v /dm-2
  dhclient
else
  mount -o nodev,noatime,inode64,allocsize=16m /dev/nvme0n1 /gpdb
  dd if=/dev/zero of=/dm-2 count=32768 bs=1MiB
  chmod 600 /dm-2
  mkswap /dm-2
  swapon -v /dm-2
  dhclient
fi
