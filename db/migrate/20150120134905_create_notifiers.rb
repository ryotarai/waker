class CreateNotifiers < ActiveRecord::Migration
  def change
    create_table :notifiers do |t|
      t.integer :type
      t.text :settings
      t.integer :notify_after_sec

      t.timestamps null: false
    end
  end
end
