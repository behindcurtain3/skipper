class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :token, :null => false
      t.string :title, :null => false
      t.string :url
      t.string :text
      t.integer :user_id, :null => false
      t.integer :sub_id, :null => false

      t.timestamps null: false
    end

    add_index :posts, :token, :unique => true
    add_index :posts, :user_id
    add_index :posts, :sub_id
  end
end
