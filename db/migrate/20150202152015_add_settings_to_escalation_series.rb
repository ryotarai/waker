class AddSettingsToEscalationSeries < ActiveRecord::Migration
  def change
    add_column :escalation_series, :escalation_series, :text
  end
end
