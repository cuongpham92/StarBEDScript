SCRIPT = "sed -i 's/HOST_ID=$(printf \"%x\" 1);/HOST_ID=$(printf \"%x\" $1);/g' 01_create_virt_xml.sh";
SCRIPT_FOLDER="~/work/xml";
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
				if (group_id < 100)
					hosts << "#{group_code}0#{group_id}"
				else
					hosts << "#{group_code}#{group_id}"
				end
			end
		end
	end

	return hosts
end

hosts=extract_hosts(ARGV[0])

hosts.each_with_index do |host, host_index|
	command = "cd #{SCRIPT_FOLDER} && #{SCRIPT}"
	ssh_command = "ssh -o StrictHostKeyChecking=no -l #{USERNAME} #{host} \"#{command}\""

	puts(ssh_command)
end