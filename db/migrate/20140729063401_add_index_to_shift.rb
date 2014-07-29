class AddIndexToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :index, :integer
  end
end
