class PayType < ActiveRecord::Base
  validates_presence_of :display_name, :value
  validates_uniqueness_of :display_name, :value
end
