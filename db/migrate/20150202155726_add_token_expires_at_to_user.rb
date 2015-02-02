class AddTokenExpiresAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :token_expires_at, :datetime
  end
end
