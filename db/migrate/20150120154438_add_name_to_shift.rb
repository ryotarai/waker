class AddNameToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :name, :string
  end
end
