class RenameSubmissionFile < ActiveRecord::Migration
  def up
    remove_attachment :submissions, :zipfile
    add_attachment :submissions, :datafile
  end

  def down
    remove_attachment :submissions, :datafile
    add_attachment :submissions, :zipfile
  end
end
