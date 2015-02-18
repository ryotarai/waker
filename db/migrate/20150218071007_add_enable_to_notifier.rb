class AddEnableToNotifier < ActiveRecord::Migration
  def change
    add_column :notifiers, :enabled, :boolean, default: true
  end
end
