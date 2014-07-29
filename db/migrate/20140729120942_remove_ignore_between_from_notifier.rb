class RemoveIgnoreBetweenFromNotifier < ActiveRecord::Migration
  def up
    remove_column :notifiers, :ignore_between
  end

  def down
    add_column :notifiers, :ignore_between
  end
end
