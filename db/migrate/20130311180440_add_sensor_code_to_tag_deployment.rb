class AddSensorCodeToTagDeployment < ActiveRecord::Migration
  def change
  	add_column :tag_deployments, :sensor_codes, :string
  end
end
