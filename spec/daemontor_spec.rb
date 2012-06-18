require File.dirname(__FILE__) + '/spec_helper.rb'

# This is a convoluted test because of the fork, but
# it should serve its purpose.
describe "Test basic functionality of Daemontor" do

  it "should spawn a new daemon and kill it" do
    begin
      master_pid = Process.pid.to_s
      pids = []
      puts "*** PID: #{Process.pid}"
      tester = TesterClass.new
      puts "****** PID: #{Process.pid}"
      retval = false

      if( Process.pid.to_s == master_pid )
        puts "IN MASTER LOGIC: Child => #{tester.cpid}"
        pids << tester.cpid.to_s
        pids.each do |pid|
          puts "KILLING PID: #{pid}"
          Process.kill("INT", pid.to_i)
        end
        retval = true
      else
        puts "IN CHILD LOGIC"
        tester.do_stuff
      end
    rescue ChildEnded => e
      puts "Child ended appropriately"
      retval = true
    end
    # if we get to this point lets just call it success :)
    retval.should be_true
  end
end
