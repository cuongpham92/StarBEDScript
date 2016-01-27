SCRIPT="./00_create_and_start.sh";
SCRIPT_FOLDER="~/work/xml";
VM_START_NUMBER = 1;
VM_END_NUMBER = 20;
USERNAME = "evaluser";

def extract_hosts(host_string)
	hosts = []

	host_groups = host_string.split(',')

	host_groups.each do |host_group|
		if host_group =~ /[ijkhlmn]\d*(:\d*)?/
			group_code = host_group[0]
			group_ids = host_group[1..-1].split(":")
			start_host_id = group_ids.first
			end_host_id = group_ids.last

			(start_host_id..end_host_id).each do |group_id|
				group_id = "0#{group_id}" if (group_id.length < 3)

				hosts << "#{group_code}#{group_id}"
			end
		end
	end

	return hosts
end

if ARGV.length < 1
	puts "Usage: start_vm.rb host_string"
	exit
end

hosts=extract_hosts(ARGV[0])
async = ARGV[1] == "-a"

hosts.each_with_index do |host, host_index|
	command = "cd #{SCRIPT_FOLDER} && #{SCRIPT} #{host_index} #{VM_START_NUMBER} #{VM_END_NUMBER}"
	ssh_command = "ssh -f -o StrictHostKeyChecking=no -l #{USERNAME} #{host} \"#{command}\""
	system(ssh_command)
end

