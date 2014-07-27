class AddStatusToIncident < ActiveRecord::Migration
  def change
    add_column :incidents, :status, :integer
  end
end
