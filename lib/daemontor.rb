require 'daemontor/version'

# This module's purpose is to daemonize processes so they can be run in the
# background like a standard UNIX daemon.  When Daemontor::daemonize is called
# the parent process fork()s a new child process and calls Process.detach so we
# don't have to wait for the child process to exit.  The parent process then
# exits and the child process goes happily on. Since we are calling
# Process.detach we do not need to do a double-fork.
#
# Thanks to the PickAxe book for good process handling information as well as
# hints from Travis Whitton's Daemonize module: http://grub.ath.cx/daemonize/
module Daemontor

  # This is the function that makes it all happen. By default the parent process
  # will be killed off.  If you want to do something with the parent afterward
  # pass a boolean true value and you will get access to the process once the
  # child is detached.
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
