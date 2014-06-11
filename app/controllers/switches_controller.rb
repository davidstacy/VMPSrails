class SwitchesController < ApplicationController
  # GET /switches
  # GET /switches.xml
  def index
    @switches = Switch.find(:all)
    
    @switches.each do |switch|
      id = switch.id.to_s
      blahtext = id
      # test
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @switches }
    end
  end

  # GET /switches/1
  # GET /switches/1.xml
  def show
    @switch = Switch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @switch }
    end
  end
  
  def ports
    require 'ciscotelnet' #located in /lib/ciscotelnet.rb
    @switch = Switch.find(params[:id])
    c = CiscoTelnet.new("Host" => @switch.ip,
                          "Password" => "pass",
                           "Enable" => "enablepass",
                           "User" => "martin",
                           "Debug" => true)
    c.open
    c.login
    c.enable
      
    c.cmd("term length 0")    
    result = c.cmd("show int status")
    
    render :text => "<pre>" + result + "</pre>"
    
  end

  def config
    require 'ciscotelnet' #located in /lib/ciscotelnet.rb
    @switch = Switch.find(params[:id])
    c = CiscoTelnet.new("Host" => @switch.ip,
                          "Password" => "pass",
                           "Enable" => "enablepass",
                           "User" => "martin",
                           "Debug" => true)
    c.open
    c.login
    c.enable
    
    c.cmd("term length 0")  
    result = c.cmd("show conf")
    
    render :text => "<pre>" + result + "</pre>"   
  end
  
  # GET /switches/new
  # GET /switches/new.xml
  def new
    @switch = Switch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @switch }
    end
  end

  # GET /switches/1/edit
  def edit
    @switch = Switch.find(params[:id])
  end

  # POST /switches
  # POST /switches.xml
  def create
    @switch = Switch.new(params[:switch])

    respond_to do |format|
      if @switch.save
        flash[:notice] = 'Switch was successfully created.'
        format.html { redirect_to(@switch) }
        format.xml  { render :xml => @switch, :status => :created, :location => @switch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @switch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /switches/1
  # PUT /switches/1.xml
  def update
    @switch = Switch.find(params[:id])

    respond_to do |format|
      if @switch.update_attributes(params[:switch])
        flash[:notice] = 'Switch was successfully updated.'
        format.html { redirect_to(@switch) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @switch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /switches/1
  # DELETE /switches/1.xml
  def destroy
    @switch = Switch.find(params[:id])
    @switch.destroy

    respond_to do |format|
      format.html { redirect_to(switches_url) }
      format.xml  { head :ok }
    end
  end
  
  def showdiff
    @switch = Switch.find(params[:id],:include => :confs )
    
    
  end
end
