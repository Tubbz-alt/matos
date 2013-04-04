ActiveAdmin.register TagDeployment do

  filter :tag
  filter :tagger, :as => :select, :collection => proc { TagDeployment.all.map(&:tagger).select(&:present?).uniq.sort }
  filter :release_group, :as => :select, :collection => proc { TagDeployment.all.map(&:release_group).select(&:present?).uniq.sort }
  filter :common_name, :as => :check_boxes, :collection => proc { TagDeployment.all.map(&:common_name).select(&:present?).uniq.sort }
  filter :scientific_name, :as => :check_boxes, :collection => proc { TagDeployment.all.map(&:scientific_name).select(&:present?).uniq.sort }
  filter :capture_date
  filter :release_date  
  filter :capture_location
  filter :release_location

  index do
    selectable_column
    id_column

    column :tag
    column :report
    column :common_name
    column :scientific_name
    column :release_group
    column :capture_location
    column :length
    column :weight
    column :tagger

    default_actions
  end

  #form do |f| 
  #  f.inputs do
  #  end
  #  f.actions
  #end

  show do |s|
    attributes_table do
      row :tag
      row :tagger
      row :common_name
      row :scientific_name
      row :capture_location
      row :capture_geo
      row :capture_date
      row :wild_or_hatchery
      row :stock
      row :length
      row :weight
      row :age
      row :sex
      row :dna_sample_taken
      row :treatment_type
      row :temperature_change
      row :holding_temperature
      row :surgery_location
      row :surgery_geo
      row :surgery_date
      row :sedative
      row :sedative_concentration
      row :anaesthetic
      row :anaesthetic_concentration
      row :buffer
      row :buffer_concentration_in_anaesthetic
      row :anesthetic_concentration_in_recirculation
      row :buffer_concentration_in_recirculation
      row :do
      row :description
      row :release_group
      row :release_location
      row :release_geo
      row :release_date
      row :lifespan
      row :expiration_date
      row :length_type
      row :implant_type
      row :external_codes
    end
    active_admin_comments
  end

end