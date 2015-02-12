class AddUserToNotifier < ActiveRecord::Migration
  def change
    add_reference :notifiers, :user, index: true
    add_foreign_key :notifiers, :users
  end
end
