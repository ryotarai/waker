class CreateComments < ActiveRecord::Migration
  def change
    create_table "comments", force: :cascade do |t|
      t.integer  "incident_id", limit: 4,   null: false
      t.integer  "user_id",     limit: 4,   null: false
      t.string   "comment",     limit: 255, null: false
      t.datetime "created_at",              null: false
      t.datetime "updated_at",              null: false
    end
  end
end
