class AddUserIdToNotifier < ActiveRecord::Migration
  def change
    add_column :notifiers, :user_id, :integer
    add_index :notifiers, :user_id
  end
end
