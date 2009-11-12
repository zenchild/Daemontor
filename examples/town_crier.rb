$: << '../lib'
require 'daemontor'

class TownCrier
	include Daemontor
	
	def initialize
		$DEBUG = true  # Set this so output doesn't go to the background in the example.
		pid = daemonize!
		puts "Process running in background as PID: #{Process.pid}"
	end

	def cry
		loop do
			puts "It's #{Time.now.to_s} and all is well"
			sleep 10
		end
	end

	def pid
		return Process.pid
	end
end

