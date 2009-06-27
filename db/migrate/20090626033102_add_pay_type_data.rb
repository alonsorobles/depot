class AddPayTypeData < ActiveRecord::Migration
  def self.up
    PayType.delete_all
    
    PayType.create(:display_name => "Check", :value => "check")
    PayType.create(:display_name => "Credit card", :value => "cc")
    PayType.create(:display_name => "Purchase order", :value => "po")
  end

  def self.down
    PayType.delete_all
  end
end
