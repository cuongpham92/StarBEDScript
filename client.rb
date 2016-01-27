require 'socket'

HOST = 'localhost'
PORT = 6789

socket = TCPSocket.open(HOST, PORT)

socket.close