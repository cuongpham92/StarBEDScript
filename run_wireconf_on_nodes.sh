#get the ip of my 'default' network interface
HOST_IP=`/sbin/ifconfig default | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
CURRENT_HOST_INDEX=$(echo ${HOST_IP} | tr "." " " | awk '{ print $4 }')
echo $CURRENT_HOST_INDEX
TOTAL_NODE=$1
for NUM in $(seq 1 20)
do
	NODE_ID=`expr $CURRENT_HOST_INDEX \* 20 + $NUM - 1`;
	./execute_on_vm.sh 10.0.$CURRENT_HOST_INDEX.$NUM "./execute_wireconf.sh $NODE_ID $TOTAL_NODE > wire_conf_${CURRENT_HOST_INDEX}_$NUM.log 2>&1 &" -f
done
