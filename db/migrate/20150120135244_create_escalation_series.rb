class CreateEscalationSeries < ActiveRecord::Migration
  def change
    create_table :escalation_series do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
