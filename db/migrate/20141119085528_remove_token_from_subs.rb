class RemoveTokenFromSubs < ActiveRecord::Migration
  def change
  	remove_column :subs, :token
  end
end
