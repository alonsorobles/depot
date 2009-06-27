class CreatePayTypes < ActiveRecord::Migration
  def self.up
    create_table :pay_types do |t|
      t.string :display_name
      t.string :value, :limit => 10

      t.timestamps
    end
  end

  def self.down
    drop_table :pay_types
  end
end
