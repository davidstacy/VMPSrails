class PortsController < ApplicationController

  def index
    if params[:switchport] && params[:switchid]
      @switchport = params[:switchport]
      @switch = Switch.find(params[:switchid])
    else
      render :portsearch
    end  
  end
  
  def status
    @switchport = params[:switchport]
    @switch = Switch.find(params[:switchid])

    c = ciscologin(@switch.ip)
    c.cmd("term length 0")    
    result = c.cmd("show int "+ @switchport +" status")
    c.close

    render :text => "<pre>" + result + "</pre>"
  end
  
  def macaddress
    @switchport = params[:switchport]
    @switch = Switch.find(params[:switchid])

    c = ciscologin(@switch.ip)
    c.cmd("term length 0")    
    result = c.cmd("show mac address-table int "+ @switchport )
    c.close

    render :text => "<pre>" + result + "</pre>"
  end
  
  def reconfirm
    @switch = Switch.find(params[:switchid])

    c = ciscologin(@switch.ip)
    c.cmd("term length 0")    
    result = c.cmd("vmps reconfirm" )
    c.close

    render :text => "<pre>" + result + "</pre>"
  end
end
