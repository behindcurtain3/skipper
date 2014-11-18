class CreateCrews < ActiveRecord::Migration
  def change
    create_table :crews do |t|
    	t.string :name, :null => false, :default => ""
    	t.string :title, :null => false, :default => ""
    	t.string :description

    	t.integer :creator_id, :null => true

      t.timestamps
    end

    add_index :crews, :creator_id
  end
end
