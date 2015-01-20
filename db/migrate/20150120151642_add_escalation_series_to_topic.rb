class AddEscalationSeriesToTopic < ActiveRecord::Migration
  def change
    add_reference :topics, :escalation_series, index: true
    add_foreign_key :topics, :escalation_series
  end
end
