class Main
	def initialize(total_node = 20, async = true)
		@total_node = total_node.to_i
		@async = async
		@ssh_option = @async ? "-f" : ""

		@total_host = @total_node / 20

		@all_hosts = File.read("all-nodes.conf").split("\n")

		@selected_hosts = @all_hosts[0..@total_host-1]

		@all_vm_ips = [].tap do |ips|
			(0..49).each do |host_id|
				(1..20).each do |vm_id|
					ips << "10.0.#{host_id}.#{vm_id}"
				end
			end
		end

		true
	end

	def run_command_on_guests(host_index, command)
		get_vm_ips_on_host(host_index).each do |vm_ip|
			puts "\trun command on #{vm_ip}"

			`ssh #{@ssh_option} root@#{vm_ip} '#{command}'`
		end
	end

	def run_command_on_hosts(command)
		if @async
			ssh_command = "parallel-ssh -p #{@selected_hosts.count} -t -1 -i -H '#{@selected_hosts.join(' ')}' -l evaluser '#{command}'"
			system(ssh_command)
		else
			@selected_hosts.each do |host_ip|
				puts "run command on #{host_ip}"
				before = Time.now
				ssh_command = "ssh evaluser@#{host_ip} '#{command}'"
				puts ssh_command
				system(ssh_command)
				after = Time.now

				puts "total_time: #{after - before} seconds"
			end
		end

	end

	def run_ping_test
		Process.spawn("ruby /home/evaluser/master_scripts/server.rb #{@total_node} > /home/evaluser/master_scripts/server.log")
		run_command_on_hosts("./run_ping_test_on_nodes.sh #{@total_node} #{@ssh_option}")

		download_ping_log
	end

	def remove_ping_log(from_host, to_host)
		(from_host..to_host).each do |host_id|
			run_command_on_guests(host_id, "rm -f ping_test*.log")
		end
	end

	def download_ping_log
		log_path = "~/ping_log/#{@total_node}_#{Time.now.strftime("%Y%m%d_%H%M")}"
		`mkdir -p #{log_path}`

		@selected_hosts.each_with_index do |host_ip, host_index|
			get_vm_ips_on_host(host_index).each do |vm_ip|
				Process.spawn("scp root@#{vm_ip}:ping_test*.log #{log_path} && ssh root@#{vm_ip} 'rm ping_test*.log'")
			end
		end
	end

	def start_vm(async = true)
		system("ruby start_vm.rb #{@selected_hosts.join(',')} #{async ? '-a' : ''}")
	end

	def start_wireconf
		run_command_on_hosts("./run_wireconf_on_nodes.sh #{@selected_hosts.count * 20}")
	end

	private
	def get_vm_ips_on_host(host_index)
		[].tap do |ips|
			(1..20).each do |i|
				ips << "10.0.#{host_index}.#{i}"
			end
		end
	end

	def measure_time(&block)
		before = Time.now
		yield
		after = Time.now
	end
end

total_node = ARGV[0] || 20
async = ARGV[1] || true

main = Main.new(total_node, async)