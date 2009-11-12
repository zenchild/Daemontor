#############################################################################
# Copyright © 2009 Dan Wanek <dan.wanek@gmail.com>
#
#
# This file is part of Daemontor.
# 
# Daemontor is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
# 
# Daemontor is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with Daemontor.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

=begin rdoc
This modules purpose is to daemonize processes so they can be run in the background like a
standard UNIX daemon.  When Daemontor::daemonize is called the parent process fork()s a
new child process and calls Process.detach so we don't have to wait for the child process
to exit.  The parent process then exits and the child process goes happily on.  Since we are
calling Process.detach we do not need to do a double-fork

Thanks to the PickAxe book for good process handling information as well as hints from
Travis Whitton's Daemonize module: http://grub.ath.cx/daemonize/
=end
module Daemontor
	VERSION = '0.0.1'

	# This is the function that makes it all happen.  By default the parent process
	# will be killed off.  If you want to do something with the parent afterword pass a
	# boolean true value and you will get access to the process back once the child is
	# detached.
	def daemonize!(keep_parent_alive = false)
		puts "Doing fork " + Process.pid.to_s if $DEBUG


		if((cpid = fork).nil?)
			# Only the child processes should get here
			trap("INT", proc {p_int} )
			trap("QUIT", proc {p_quit} )
			trap("TERM", proc {p_term} )
			trap("KILL", proc {p_kill} )
			unless $DEBUG
				STDIN.reopen "/dev/null"
				STDOUT.reopen "/dev/null", "a"
				STDERR.reopen STDOUT
			end
		else
			# Only the parent processes should get here.  We detach from a specific
			# PID so we don't globally detach from all PIDs.  This may be handy when you need some
			# children to return and some not to.  The logic isn't here to do that yet, but it
			# should be relatively easy to implement with this already in place.
			puts "Detaching from child process #{cpid}" if $DEBUG
			Process.detach(cpid)
			exit unless keep_parent_alive
		end
		return cpid
	end


	# *********************************************************************************
	# You might want to overide the following methods to do something a little smarter.
	# *********************************************************************************

	def p_int
		warn "Process interupt recieved.  Killing process"
		p_kill
	end

	def p_quit
		warn "Process quit recieved.  Killing process"
		p_kill
	end

	def p_term
		warn "Process termination recieved.  Killing process"
		p_kill
	end

	def p_kill
		warn "Killing process #{Process.pid.to_s}"
		exit
	end
end
