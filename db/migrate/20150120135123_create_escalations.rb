class CreateEscalations < ActiveRecord::Migration
  def change
    create_table :escalations do |t|
      t.references :escalate_to, index: true
      t.integer :escalate_after_sec

      t.timestamps null: false
    end
    add_foreign_key :escalations, :escalate_tos
  end
end
