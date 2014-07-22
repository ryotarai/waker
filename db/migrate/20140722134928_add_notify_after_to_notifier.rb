class AddNotifyAfterToNotifier < ActiveRecord::Migration
  def change
    add_column :notifiers, :notify_after, :integer
  end
end
