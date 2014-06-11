class Switch < ActiveRecord::Base
  set_primary_key "switchuid"
  has_many :confs
  extend HTMLDiff
end