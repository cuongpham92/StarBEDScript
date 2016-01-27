#get the ip of my 'default' network interface
HOST_IP=`/sbin/ifconfig default | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
CURRENT_HOST_INDEX=$(echo ${HOST_IP} | tr "." " " | awk '{ print $4 }')
echo $CURRENT_HOST_INDEX

TOTAL_NODES=$1
ASYNC_OPTION=$2

for NUM in $(seq 1 20)
do
	./execute_on_vm.sh 10.0.$CURRENT_HOST_INDEX.$NUM "./ping_test.sh $TOTAL_NODES > ping_test_${CURRENT_HOST_INDEX}_$NUM.log ; ruby client.rb" $ASYNC_OPTION
done
