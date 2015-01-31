class SetDefaultOfEnableOfTopicTrue < ActiveRecord::Migration
  def change
    change_column :topics, :enable, :boolean, default: true
  end
end
