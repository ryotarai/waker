class CreateNotifiers < ActiveRecord::Migration
  def change
    create_table :notifiers do |t|
      t.string :name
      t.string :kind
      t.text :details_json
    end
  end
end
