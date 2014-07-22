class RenameTypeToKind < ActiveRecord::Migration
  def change
    change_table :providers do |t|
      t.rename :type, :kind
    end
  end
end
