count = 0
(0..49).each do |host_id|
	(1..20).each do |vm_id|
		puts "running on #{host_id}-#{vm_id}"
		command = "ssh -f -o StrictHostKeyChecking=no root@10.0.#{host_id}.#{vm_id} './kill_wireconf.sh'"
		#command = "ssh -f -o StrictHostKeyChecking=no root@10.0.#{host_id}.#{vm_id} 'nohup ./execute_wireconf.sh #{count} > /dev/null 2>&1 &'"
		system(command)
		count = count+1
	end
end