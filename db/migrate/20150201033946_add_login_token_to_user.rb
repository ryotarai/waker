class AddLoginTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :login_token, :string
  end
end
