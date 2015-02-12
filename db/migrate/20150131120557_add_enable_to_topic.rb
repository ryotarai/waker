class AddEnableToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :enable, :boolean
  end
end
