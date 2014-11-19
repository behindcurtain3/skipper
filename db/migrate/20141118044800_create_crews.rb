class CreateCrews < ActiveRecord::Migration
  def change
    create_table :subs do |t|
    	t.string :token, :null => false
    	t.string :name, :null => false, :default => ""
    	t.string :title, :null => false, :default => ""
    	t.string :description

    	t.integer :creator_id, :null => true

      t.timestamps
    end

    add_index :subs, :token, :unique => true
    add_index :subs, :creator_id
  end
end
