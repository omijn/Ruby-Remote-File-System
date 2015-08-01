require 'socket'      # Sockets are in standard library

hostname = 'localhost'
port = 2000

socket = TCPSocket.open(hostname, port)

while line = socket.gets   # Read lines from the socket
  puts line              # And print with platform line terminator
end

socket.close
