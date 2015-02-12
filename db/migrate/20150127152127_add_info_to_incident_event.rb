class AddInfoToIncidentEvent < ActiveRecord::Migration
  def change
    add_column :incident_events, :info, :text
  end
end
