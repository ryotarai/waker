class CreateNotifierProviders < ActiveRecord::Migration
  def change
    create_table :notifier_providers do |t|
      t.string :name
      t.integer :kind
      t.text :settings

      t.timestamps null: false
    end
  end
end
