class AddCommentIndex < ActiveRecord::Migration
  def change
    add_index :comments, :incident_id
  end
end
