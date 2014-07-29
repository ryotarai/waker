class AddIgnorePeriodsJsonToNotifier < ActiveRecord::Migration
  def change
    add_column :notifiers, :ignore_periods_json, :text
  end
end
