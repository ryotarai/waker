class AddCreatedAndUpdatedToIncident < ActiveRecord::Migration
  def change
    add_column :incidents, :created_at, :datetime
    add_column :incidents, :updated_at, :datetime
  end
end
