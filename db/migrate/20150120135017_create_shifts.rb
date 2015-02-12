class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :shifts, :users
  end
end
