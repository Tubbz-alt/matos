class MoveFieldsToTagDeployment < ActiveRecord::Migration
  def up
    remove_column :tags, :lifespan
    remove_column :tags, :endoflife

    add_column :tag_deployments, :lifespan, :string
    add_column :tag_deployments, :expiration_date, :datetime
  end

  def down
    add_column :tags, :lifespan, :string
    add_column :tags, :endoflife, :datetime

    remove_column :tag_deployments, :lifespan
    remove_column :tag_deployments, :expiration_date
  end
end
