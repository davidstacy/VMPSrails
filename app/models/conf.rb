class Conf < ActiveRecord::Base
  belongs_to :switch
  
  extend HTMLDiff
end
