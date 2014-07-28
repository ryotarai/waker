class AddCheckHashToIncident < ActiveRecord::Migration
  def change
    add_column :incidents, :check_hash, :string
  end
end
