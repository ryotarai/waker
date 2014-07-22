class AddDetailsJsonToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :details_json, :text
  end
end
