(0..49).each do |host_id|
	(1..20).each do |vm_id|
		command = "scp root@10.0.#{host_id}.#{vm_id}:ping_test_#{host_id}_#{vm_id}.log ."
		system(command)
	end
end