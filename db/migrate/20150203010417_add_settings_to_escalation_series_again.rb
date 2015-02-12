class AddSettingsToEscalationSeriesAgain < ActiveRecord::Migration
  def change
    add_column :escalation_series, :settings, :text
  end
end
