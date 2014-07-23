class CreateNotificationQueues < ActiveRecord::Migration
  def change
    create_table :notification_queues do |t|
      t.references :notifier, index: true
      t.references :incident, index: true
      t.datetime :notify_at

      t.timestamps
    end
  end
end
