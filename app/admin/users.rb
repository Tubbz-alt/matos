ActiveAdmin.register User do

  menu :if => proc{ can? :manage, User }

  filter :name
  filter :email
  filter :organization
  filter :role
  filter :requested_role
  filter :approved
  filter :newsletter

  index do
    selectable_column
    id_column
    
    column :name
    column :email
    column :organization
    column :remember_me
    column :role
    column :requested_role
    column :approved
    column :newsletter

    default_actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :email
      if f.object.id.nil?
        f.input :password
        f.input :password_confirmation
      end
      f.input :organization
      f.input :role, :as => :select, :collection => User::REGISTERABLE_ROLES.map{|r|["#{r.humanize} - #{User::ROLE_MAP[r.to_sym]}",r]}
      f.input :requested_role
      f.input :approved
      f.input :newsletter
      f.input :address
      f.input :city
      f.input :state
      f.input :zipcode
      f.input :phone
    end
    f.actions
  end

  show do |s|
    attributes_table do
      row :name
      row :email
      row :organization
      row :role
      row :requested_role
      row :approved
      row :newsletter
      row :address
      row :city
      row :state
      row :zipcode
      row :phone
    end
    active_admin_comments
  end

end
