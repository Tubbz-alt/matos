ActiveAdmin.register Tag do

  filter :code_space, :as => :select, :collection => proc { Tag.all.map(&:code_space).select(&:present?).uniq.sort }
  filter :serial
  filter :code  
  filter :model, :as => :check_boxes, :collection => proc { Tag.all.map(&:model).select(&:present?).uniq.sort }
  filter :manufacturer, :as => :check_boxes, :collection => proc { Tag.all.map(&:manufacturer).select(&:present?).uniq.sort }

  index do
    selectable_column
    id_column

    column :active_deployment
    column :code_space
    column :code
    column :manufacturer
    column :model
    column :serial

    default_actions
  end

  form do |f| 
    f.inputs do
      f.input :code
      f.input :code_space
      f.input :model
      f.input :manufacturer
      f.input :serial
      f.input :type
      f.input :description
      f.input :endoflife
    end
    f.actions
  end

  show do |s|
    attributes_table do
      row :code
      row :code_space
      row :model
      row :manufacturer
      row :serial
      row :type
      row :description
      row :endoflife
    end
    active_admin_comments
  end

end