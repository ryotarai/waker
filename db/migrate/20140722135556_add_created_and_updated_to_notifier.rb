class AddCreatedAndUpdatedToNotifier < ActiveRecord::Migration
  def change
    add_column :notifiers, :created_at, :datetime
    add_column :notifiers, :updated_at, :datetime
  end
end
