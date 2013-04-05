class RemoveZAndMDimensions < ActiveRecord::Migration
  def up
    remove_column :hits,                    :location
    remove_column :receiver_deployments,    :location
    add_column :hits,                    :location, :point, :srid => 4326, :geographic => true
    add_column :receiver_deployments,    :location, :point, :srid => 4326, :geographic => true    
  end

  def down
    remove_column :hits,                    :location
    remove_column :receiver_deployments,    :location
    add_column :hits,                    :location, :point, :srid => 4326, :geographic => true, :has_m => true, :has_z => true, :spatial => true
    add_column :receiver_deployments,    :location, :point, :srid => 4326, :geographic => true, :has_m => true, :has_z => true, :spatial => true
  end
end
