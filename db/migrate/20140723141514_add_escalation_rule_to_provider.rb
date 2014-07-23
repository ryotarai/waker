class AddEscalationRuleToProvider < ActiveRecord::Migration
  def change
    add_reference :providers, :escalation_rule, index: true
  end
end
