ActiveAdmin.register ReceiverDeployment do

  filter :study
  filter :otn_array
  filter :start
  filter :name
  filter :station
  filter :seasonal
  filter :proposed
  filter :funded

  index do
    selectable_column
    id_column

    column :study
    column :otn_array
    column :code, :sortable => false
    column :consecutive
    column :latitude, :sortable => false
    column :longitude
    column :start
    column :ending

    default_actions
  end

  show do |s|
    attributes_table do
      row :study
      row :otn_array
      row :code      
      row :consecutive
      row :latitude
      row :longitude
      row :location
      row :start
      row :ending
      row :riser_length
      row :bottom_depth      
      row :instrument_depth
      row :deployed_by
      row :seasonal
      row :funded
      row :proposed
      row :hits
    end

    active_admin_comments
  end

end
