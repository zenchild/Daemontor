$: << '../lib'
require 'daemontor'

class TownCrier
	include Daemontor
	
	def initialize
		$DEBUG = true  # Set this so output doesn't go to the background in the example.
		pid = Process.pid
		daemonize!
		puts "Process running in background as PID: #{Process.pid}"
		cry
	end

	def cry
		loop do
			puts "It's #{Time.now.to_s} and all is well"
			puts "Kill the process with 'kill -INT #{Process.pid}'"
			sleep 10
		end
	end

	def pid
		return Process.pid
	end
end


TownCrier.new
