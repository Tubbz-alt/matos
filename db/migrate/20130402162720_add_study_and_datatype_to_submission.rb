class AddStudyAndDatatypeToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :study_id, :integer
    add_column :submissions, :datatype, :string
  end
end
