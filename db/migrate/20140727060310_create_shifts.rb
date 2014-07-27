class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.string :name
      t.string :ical

      t.timestamps
    end
  end
end
