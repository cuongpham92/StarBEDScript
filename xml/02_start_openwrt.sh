#!/bin/sh

for NUM in $(seq $1 $2)
do
    virsh start  openwrt_${NUM};
done
