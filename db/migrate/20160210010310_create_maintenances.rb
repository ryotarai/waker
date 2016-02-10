class CreateMaintenances < ActiveRecord::Migration
  def change
    create_table :maintenances do |t|
      t.references :topic, index: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end
    add_foreign_key :maintenances, :topics
  end
end
