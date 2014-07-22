class CreateEscalations < ActiveRecord::Migration
  def change
    create_table :escalations do |t|
      t.references :escalate_to, index: true, polymorphic: true
      t.integer :escalate_after
      t.references :escalation_rule, index: true

      t.timestamps
    end
  end
end
