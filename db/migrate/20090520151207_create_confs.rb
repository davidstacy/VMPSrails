class CreateConfs < ActiveRecord::Migration
  def self.up
    create_table :confs do |t|
      t.text :configtext
      t.belongs_to :switch
      t.timestamps
    end
  end

  def self.down
    drop_table :confs
  end
end
