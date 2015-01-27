class RemoveUserByFromIncidentEvent < ActiveRecord::Migration
  def change
    remove_index  :incident_events, :user_by_id
    remove_column :incident_events, :user_by_id
  end
end
