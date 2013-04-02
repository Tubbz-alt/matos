class AddClearDataToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :cleardata, :boolean, :default => false
  end
end
