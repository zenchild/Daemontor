begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'daemontor'


class TesterClass
	include Daemontor
	attr_reader :cpid
	def initialize
		$DEBUG = true  # Set this so output doesn't go to the background in the example.
		pid = Process.pid
		@cpid = daemonize!(true)
		@run = true
	end

	def do_stuff
		while @run do
			puts "Hello, I'm process #{Process.pid}"
			sleep 15
		end
	end

	def p_int
		warn "Process interupt recieved.  Killing process"
		raise ChildEnded
		exit
	end

end

class ChildEnded < StandardError
	def message
		"Child Ended"
	end
end
