#!/bin/sh

sh ./01_create_virt_xml.sh $1 $2 $3
sh ./02_start_openwrt.sh $2 $3
