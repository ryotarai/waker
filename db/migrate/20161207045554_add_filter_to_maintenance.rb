class AddFilterToMaintenance < ActiveRecord::Migration
  def change
    add_column :maintenances, :filter, :string
  end
end
