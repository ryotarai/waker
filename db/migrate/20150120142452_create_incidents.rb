class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.string :subject
      t.text :description
      t.references :topic, index: true
      t.datetime :occured_at

      t.timestamps null: false
    end
    add_foreign_key :incidents, :topics
  end
end
