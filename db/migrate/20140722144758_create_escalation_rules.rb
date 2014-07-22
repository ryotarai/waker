class CreateEscalationRules < ActiveRecord::Migration
  def change
    create_table :escalation_rules do |t|
      t.string :name

      t.timestamps
    end
  end
end
