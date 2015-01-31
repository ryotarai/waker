class RenameEnableWithEnabledOfTopic < ActiveRecord::Migration
  def change
    rename_column :topics, :enable, :enabled
  end
end
