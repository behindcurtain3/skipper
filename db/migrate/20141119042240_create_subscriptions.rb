class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id
      t.integer :sub_id

      t.timestamps null: false
    end

    add_index :subscriptions, :subscriber_id
    add_index :subscriptions, :sub_id
    add_index :subscriptions, [:subscriber_id, :sub_id], unique: true
  end
end
