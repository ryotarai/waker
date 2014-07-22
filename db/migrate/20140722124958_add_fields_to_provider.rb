class AddFieldsToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :name, :string
    add_column :providers, :type, :string
  end
end
