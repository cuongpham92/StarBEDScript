cat all-nodes.conf | awk '
	NR >=2 {
		system("./execute_on_host.sh " $1 " \"sudo chown evaluser ~/centos_base.qcow2\"");
		system("./distribute.sh ~/centos_base.qcow2 " $1 " ~");
	}'