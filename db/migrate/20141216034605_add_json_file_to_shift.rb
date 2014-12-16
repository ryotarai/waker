class AddJsonFileToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :json_file, :string
  end
end
