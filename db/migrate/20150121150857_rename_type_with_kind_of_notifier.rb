class RenameTypeWithKindOfNotifier < ActiveRecord::Migration
  def change
    rename_column :notifiers, :type, :kind
  end
end
