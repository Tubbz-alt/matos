ActiveAdmin.register Receiver do

  filter :model
  filter :serial
  filter :frequency
  filter :vps

  index do
    selectable_column
    id_column

    column :model
    column :serial
    column :frequency
    column :vps
    
    default_actions
  end

  show do |s|
    attributes_table do
      row :model
      row :serial
      row :frequency
      row :vps
      row :rcv_modem_address
    end

    active_admin_comments
  end

end
