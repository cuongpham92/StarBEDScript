NUMBER_OF_NODES=$1

if [ -z "$1" ]
	then
		NUMBER_OF_NODES=20
fi

IP_ADDRESS=`/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

cat ${NUMBER_OF_NODES}nodes.conf | gawk 'BEGIN{
	current_ip = "'${IP_ADDRESS}'";
	split(current_ip, ipoct, ".");
	host_id = ipoct[3];
	vm_id = ipoct[4];
}
{
	split($0, target_ipoct, ".");
	if(target_ipoct[3] > host_id || (target_ipoct[3] == host_id && target_ipoct[4] > vm_id)){
		system("ping -f -W 1 -c 10 " $0)
	}
}' | grep -e packet -e statistics -e rtt