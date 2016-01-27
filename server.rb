require 'socket'

PORT = 6789
MAX_WAITING_HOST = ARGV[0].to_i
waiting_host = MAX_WAITING_HOST

start_time = Time.now
end_time = Time.now
server = TCPServer.open(PORT)

puts "Waiting for #{MAX_WAITING_HOST} clients at #{Time.now}"
puts "===="

loop {
	waiting_host = waiting_host - 1
	Thread.start(server.accept) do |client|
		sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
		puts "Received connection from #{remote_ip} at #{Time.now} \n"
		client.close
	end

	if waiting_host <= 0
		puts "All clients have started"
		end_time = Time.now
		break
	end
}


puts "Start time: #{start_time}"
puts "End time: #{end_time}"
puts "Time duration: #{end_time - start_time} seconds"
