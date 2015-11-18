class DeleteTokenFromUser < ActiveRecord::Migration
  def change
    User.all.each do |u|
      if u.token
        u.update!(credentials: {
          token: u.token,
          refresh_token: u.refresh_token,
          expires_at: u.token_expires_at.to_i,
          expires: true,
        })
      end
    end

    remove_column :users, :token
    remove_column :users, :token_expires_at
    remove_column :users, :refresh_token
  end
end
