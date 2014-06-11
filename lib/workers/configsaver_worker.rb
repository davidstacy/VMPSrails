class ConfigsaverWorker < BackgrounDRb::MetaWorker
  set_worker_name :configsaver_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def save_configs
    #get switches
    @switches = Switch.find(:all)
    
    #loop through switches
    for switch in @switches do
      #get config
      c = ciscologin(switch.ip)
      c.cmd("term length 0")  
      currentconf = c.cmd("show config")
      c.close
      
      #load config into db
      #Conf.create(:configtext => currentconf, :switch_id => switch.id)            

      #save as a file - filename corresponds to conf.id
      
      filename = "#{switch.name}-#{Time.now.strftime('%Y%m%d%H%M%S')}.conf"
      fullpath = "#{RAILS_ROOT}/public/confstorage/#{filename}"
      conf = Conf.create(:filename => filename, :switch_id => switch.id)
      
      File.open(fullpath,"w+") do |f|
        f.puts(currentconf)
      end
    end
  end
end