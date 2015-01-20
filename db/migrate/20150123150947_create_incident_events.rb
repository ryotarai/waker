class CreateIncidentEvents < ActiveRecord::Migration
  def change
    create_table :incident_events do |t|
      t.references :incident, index: true
      t.integer :kind
      t.text :text
      t.references :user_by, index: true

      t.timestamps null: false
    end
    add_foreign_key :incident_events, :incidents
    add_foreign_key :incident_events, :user_bies
  end
end
