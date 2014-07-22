class CreateIncident < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.text :description
      t.text :details_json
      t.references :provider, index: true
    end
  end
end
