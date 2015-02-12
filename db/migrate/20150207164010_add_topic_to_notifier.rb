class AddTopicToNotifier < ActiveRecord::Migration
  def change
    add_reference :notifiers, :topic, index: true
    add_foreign_key :notifiers, :topics
  end
end
