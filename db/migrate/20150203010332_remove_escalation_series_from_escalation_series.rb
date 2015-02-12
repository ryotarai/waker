class RemoveEscalationSeriesFromEscalationSeries < ActiveRecord::Migration
  def change
    remove_column :escalation_series, :escalation_series
  end
end
