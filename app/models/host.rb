class Host < ActiveRecord::Base
  validates_format_of :mac, :with => /([0-9a-f]){4}\.([0-9a-f]){4}\.([0-9a-f]){4}/, :on => :create, :message => "format xxxx.xxxx.xxxx lowercase"

end
