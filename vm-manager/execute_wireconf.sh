/root/kill_wireconf.sh

NODE=$1
TOTAL_NODE=$2
insmod /root/qomet_bin/ipfw_mod.ko
/root/qomet_bin/wireconf -i $NODE -s ~/large_scale/${TOTAL_NODE}_node_scenario.settings -q ~/large_scale/${TOTAL_NODE}_node_scenario.xml.bin