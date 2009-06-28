class RenamePayTypesDisplayNameColumnToName < ActiveRecord::Migration
  def self.up
    rename_column :pay_types, :display_name, :name
  end

  def self.down
    rename_column :pay_types, :name, :display_name
  end
end
