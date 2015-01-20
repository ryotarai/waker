class RenameTypeWithKindOfTopic < ActiveRecord::Migration
  def change
    rename_column :topics, :type, :kind
  end
end
