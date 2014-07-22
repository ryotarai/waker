class AddCreatedAndUpdatedToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :created_at, :datetime
    add_column :providers, :updated_at, :datetime
  end
end
