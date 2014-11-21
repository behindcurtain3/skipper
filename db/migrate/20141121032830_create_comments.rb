class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :token, :null => false
    	t.integer :user_id, :null => false
    	t.integer :post_id, :null => false
    	t.integer :parent_id
    	t.text :content, :null => false

      t.timestamps null: false
    end

    add_index :comments, :token, :unique => true
    add_index :comments, :user_id
    add_index :comments, :post_id
    add_index :comments, :parent_id
  end
end
