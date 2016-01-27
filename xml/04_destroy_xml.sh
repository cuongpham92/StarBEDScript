#!/bin/sh


virsh list --all | awk '{
    if($0 ~ /openwrt_/) {
        destroy_cmd = "virsh undefine " $2;
        system(destroy_cmd);
    }
}'
ps auxwww | grep diff_ | awk '{system("sudo kill -9 " $2)}'
sudo rm /home/evaluser/openwrt_diff_*
