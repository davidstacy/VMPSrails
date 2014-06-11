class MainController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy] 
  auto_complete_for :host, :mac
  
  def index
    
  end
  
  def searchresult
    #@host = Host.find(params["host[mac]"])
    render :update do |page|
      page.replace_html "searchresults", params[:host => ["mac"]]
      page.show("searchresults")
    end
  end
  
  
  def auto_complete_for_host_mac
    #check if it's an IP address format, if it is do something different
    if params[:host][:mac] =~ /\A(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)(?:\.(?:25[0-5]|(?:2[0-4]|1\d|[1-9])?\d)){3}\z/
      render :update do |page|
        page.hide "instructions"
        page.hide "searchresults"
        page.hide "spinner"
        page.replace_html "hostinfo", :partial => "ipcheck"

      end
    
    else #looking for a hostname or mac address  
      @results = Host.find_by_sql(
        'SELECT h.id,h.hostname,h.mac,h.vlan
        FROM hosts h
        WHERE 
          h.mac LIKE "%' + params[:host][:mac] + '%"
          OR
          h.hostname LIKE "%' + params[:host][:mac] + '%" 
        LIMIT 10')    
  
      render :update do |page|
        page.replace_html "hostinfo", :text => ""
        page.replace_html "searchresults", :partial => "searchresults"
        page.show "searchresults"
        page.hide "spinner"
        page.hide "instructions"
      end #end render
    end  
    

  end
  
  def ipsearch
    searchip = params[:ip]
    
    #reverse dns lookup
    require 'resolv-replace.rb'
    @dnsname = Resolv.getname(searchip).to_s

    #arp check on cisco switches
    #checking against the active or passive router is a good bet          
    c=ciscologin("10.1.1.1")
      
    c.cmd("term length 0")    
    result = c.cmd("show arp")
    result.each_line do |line|
      #if the line has our IP in it we have a winner
      if searchip == line.split(" ")[1] #2nd column is ip
        @foundmac = line.split(" ")[3]  #4th column is mac
        @foundvlan = line.split(" ")[5]  #6th column is vlan
      end
    end
    
    c.close
    
    #check any returned mac address against the vmps database
    @switch,@port = locatebymac(@foundmac)
    
    #check against VMPS database
    @host = Host.find_by_mac(@foundmac)

  end  

end
