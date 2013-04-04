class RenameDeploymentsToReceivers < ActiveRecord::Migration
  def up

    remove_column :deployments, :location
    remove_column :deployments, :start
    remove_column :deployments, :study_id
    remove_column :deployments, :otn_array_id
    remove_column :deployments, :station
    remove_column :deployments, :seasonal
    remove_column :deployments, :riser_length
    remove_column :deployments, :bottom_depth
    remove_column :deployments, :instrument_depth
    remove_column :deployments, :funded
    remove_column :deployments, :proposed
    remove_column :deployments, :proposed_ending
    remove_column :deployments, :consecutive
    remove_column :deployments, :deployed_by

    rename_column :deployments, :instrument_serial, :serial

    rename_table :deployments, :receivers

    create_table :receiver_deployments do |t|
        t.integer   :receiver_id
        t.point     :location,          :geographic => true, :srid => 4326, :has_m => true, :has_z => true, :spatial => true
        t.datetime  :start
        t.integer   :study_id
        t.integer   :otn_array_id
        t.string    :name
        t.integer   :station
        t.boolean   :seasonal
        t.decimal   :riser_length,      :precision => 8, :scale => 2
        t.decimal   :bottom_depth,      :precision => 8, :scale => 2
        t.decimal   :instrument_depth,  :precision => 8, :scale => 2
        t.boolean   :funded
        t.boolean   :proposed
        t.datetime  :proposed_ending
        t.integer   :consecutive
        t.string    :deployed_by
        t.datetime  :recovery_date
        t.point     :recovery_location, :geographic => true, :srid => 4326, :has_m => true, :has_z => true, :spatial => true
        t.boolean   :data_downloaded
        t.boolean   :ar_confirm
    end
    add_index :receiver_deployments, :receiver_id
    add_index :receiver_deployments, :study_id

    rename_column :hits, :deployment_id,    :receiver_deployment_id
    rename_column :hits, :deployment_code,  :receiver_code

    drop_table :retrievals

  end

  def down

    rename_table :receivers, :deployments

    rename_column :deployments, :serial, :instrument_serial

    rename_column :hits, :receiver_deployment_id,   :deployment_id
    rename_column :hits, :receiver_code,            :deployment_code

    add_column :deployments, :location,         :point, :geographic => true, :srid => 4326, :has_m => true, :has_z => true, :spatial => true
    add_column :deployments, :start,            :datetime
    add_column :deployments, :study_id,         :integer
    add_column :deployments, :otn_array_id,     :integer
    add_column :deployments, :station,          :integer
    add_column :deployments, :seasonal,         :boolean
    add_column :deployments, :riser_length,     :integer
    add_column :deployments, :bottom_depth,     :integer
    add_column :deployments, :instrument_depth, :integer
    add_column :deployments, :funded,           :boolean
    add_column :deployments, :proposed,         :boolean
    add_column :deployments, :proposed_ending,  :datetime
    add_column :deployments, :consecutive,      :integer
    add_column :deployments, :deployed_by,      :string

    drop_table :receiver_deployments

    create_table :retrievals do |t|
        t.integer   :deployment_id
        t.boolean   :data_downloaded
        t.boolean   :ar_confirm
        t.datetime  :recovered
        t.point     :location,          :geographic => true, :srid => 4326, :spatial => true
    end
    add_index :retrievals, :deployment_id

  end
end
