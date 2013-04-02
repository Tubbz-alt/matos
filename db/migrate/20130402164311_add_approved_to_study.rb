class AddApprovedToStudy < ActiveRecord::Migration
  def change
    add_column :studies, :approved, :boolean, :default => false
  end
end
