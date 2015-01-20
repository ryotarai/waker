class RemoveKindFromNotifier < ActiveRecord::Migration
  def change
    remove_column :notifiers, :kind
  end
end
