# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => ''
  
  def ciscologin(switchip)
    require 'ciscotelnet' #located in /lib/ciscotelnet.rb
    #start telnet connect helper
    c = CiscoTelnet.new("Host" => switchip,
                        "Password" => "pass",
                         "Enable" => "enablepass",
                         "User" => "martin",
                         "Debug" => true)
    c.open
    c.login
    c.enable
    return c
  end

  def locatebymac(mac)  #returns switch OBJECT and port NAME 
    #loop through switches
    @switches = Switch.find_all_by_vmps(true)
    
    require 'ciscotelnet' #located in /lib/ciscotelnet.rb
    @switches.each do |switch|
      #ciscologin custom function in application_controller
      c = ciscologin(switch.ip)

      
      result = c.cmd("show mac-address-table address " + mac)
      result.each_line do |line|
        #if the line has the word dynamic in it we have a winner
        if line.include? "dynamic"
          #split the line by white space and take the 5th (zero based) value - that will be the port
          @currentport = line.split(" ")[4]
        end
      end
      
      #make sure the port is not a trunk.
      if @currentport
        portresult = c.cmd("show int " + @currentport + " status")
        if not portresult.include? "trunk"
          @foundswitch = switch
          @foundport = @currentport
          c.close 
          break
        end #trunk check
      end #port exists
      c.close  
    end  #@switches.each
    
    return @foundswitch, @foundport
  
  end #locatebymac
end
