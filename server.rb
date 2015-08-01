require 'socket'
require 'colorize'

def authorizeUser(client)

	#authorization - 3 attempts	

	authorized = false
	3.times do
		client.puts "Enter username : "
		input_username = client.gets.chomp

		puts "Received #{input_username}".cyan
		
		if input_username == "omijn" then
			password = "server"
		end
		
		client.puts "Enter password : "
		input_password = client.gets.chomp

		if input_password == password then
			authorized = true
			client.puts "Welcome!".green.bold
			break
		end
		
		client.puts "Invalid username or password. Please try again.".red.bold
	end	
	
	if authorized == false then
		client.puts "Server closed due to authorization failure.".red	
		client.close

	end
end


def processCommand(client, command)

	case command
		when "pwd"
			client.puts "\n#{Dir.pwd}\n".green
		
		when "ls"
			base_dir = Dir.new(".")
	#		client.puts "\n"
	#		client.puts Dir.glob("*")
	#		client.puts "\n"
			base_dir.entries.each do |file|
				if File.directory? file
					client.print "\n#{file}/".cyan
				else
					client.print "\n#{file}".green
				end
			end
			client.puts "\n\n"

		when "wget"
			client.puts "\nEnter filename : "
			filename = client.gets.chomp
			

		when "exit"
			client.puts "Goodbye!\n\n".magenta.bold
			client.close

		else
			client.puts "Invalid!".red

	end			
end

server = TCPServer.new "127.0.0.1", 2000 
welcomeMessage = File.read('welcomeMessage.txt') 
menu = File.read('menu.txt')

#base_dir = Dir.new(".")

puts "Server running".green

loop do
	client = server.accept
	puts "Client connected!\n".green	

	authorizeUser(client)

=begin
	client.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{welcomeMessage.bytesize}\r\n" +
               "Connection: close\r\n"
=end
	

	client.puts "#{welcomeMessage}".cyan
	client.puts menu


	loop do
		client.print "<<<>>> ".yellow
		command = client.gets.chomp
		puts "#{command} requested".cyan
		processCommand client, command
	end 


	#client.puts "The time is #{Time.now}"

	client.close
end
