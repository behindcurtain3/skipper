class ChangeParentColumnOnComments < ActiveRecord::Migration
  def change
  	change_column :comments, :parent_id, :resource
  end
end
