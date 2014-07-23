class CreateEscalationQueues < ActiveRecord::Migration
  def change
    create_table :escalation_queues do |t|
      t.references :incident, index: true
      t.references :escalation, index: true
      t.datetime :escalate_at

      t.timestamps
    end
  end
end
