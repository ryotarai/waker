class AddIgnoreBetweenToNotifier < ActiveRecord::Migration
  def change
    add_column :notifiers, :ignore_between, :string
  end
end
