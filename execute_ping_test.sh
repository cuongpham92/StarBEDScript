USERNAME="evaluser"
PREFIX=$1

cat all-nodes.conf | awk '{
	print("Delegate this command to " $1);
	cmd = "ssh -f -o StrictHostKeyChecking=no '${USERNAME}'@" $1 " ./run_ping_test_on_nodes.sh " $PREFIX ;
	system(cmd);
}'