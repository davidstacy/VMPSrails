class Saveconftofile < ActiveRecord::Migration
  def self.up
    add_column "confs", "filename", :string
    remove_column "confs", "configtext"
    
  end

  def self.down
    add_column "confs", "configtext", :text
    remove_column "confs", "filename"
  end
end
