ActiveAdmin.register Hit do

  filter :time
  filter :tag_code
  filter :receiver_deployment, :collection => proc { ReceiverDeployment.includes(:otn_array).uniq.sort }
  filter :receiver_model
  filter :receiver_serial

  index do
    selectable_column
    id_column

    column :receiver_deployment
    column :receiver_model
    column :receiver_serial
    column :tag_deployment
    column :tag_code
    column :time
    column :location
    column :depth

    default_actions
  end

  show do |s|
    attributes_table do
        row :receiver_deployment
        row :tag_deployment
        row :tag_code
        row :time
        row :depth
        row :location
        row :receiver_model
        row :receiver_serial
    end

    active_admin_comments
  end

end
