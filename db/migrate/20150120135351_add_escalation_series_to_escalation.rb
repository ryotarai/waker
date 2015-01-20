class AddEscalationSeriesToEscalation < ActiveRecord::Migration
  def change
    add_reference :escalations, :escalation_series, index: true
    add_foreign_key :escalations, :escalation_series
  end
end
