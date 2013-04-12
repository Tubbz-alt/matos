ActiveAdmin.register Job do
  
  filter :priority
  filter :attempts

  index do
    selectable_column
    id_column

    column :priority
    column :attempts
    column :handler
    column :run_at
    column :failed_at
    column :locked_at
    column :locked_by
    column :queue
    
    default_actions
  end

  show do |s|
    attributes_table do
        row :priority
        row :attempts
        row :handler
        row :last_error
        row :run_at
        row :failed_at
        row :locked_at
        row :locked_by
        row :queue
    end

    active_admin_comments
  end

end