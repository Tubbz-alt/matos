class AddPermissionToStudy < ActiveRecord::Migration
  def change
  	add_column :studies, :permissions, :string, :default => 'private'
  end
end
