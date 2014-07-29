class CreateEventNotifiers < ActiveRecord::Migration
  def change
    create_table :event_notifiers do |t|
      t.string :kind
      t.text :details_json

      t.timestamps
    end
  end
end
