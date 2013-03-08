class AddCollaboratorsToStudies < ActiveRecord::Migration
  def change

    create_table(:collaborators) do |t|
      t.integer             :study_id
      t.integer             :user_id
      t.string              :role
      t.timestamps
    end

  end
end
