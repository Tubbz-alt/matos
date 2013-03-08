ActiveAdmin.register Study do

  filter :code, :as => :check_boxes, :collection => proc { Study.all.map(&:code).select(&:present?).uniq }
  filter :name
  filter :start
  filter :ending
  filter :species, :as => :check_boxes, :collection => proc { Study.all.map(&:species).select(&:present?).uniq }
  filter :user_id

  index do
    selectable_column
    id_column

    column :code
    column :name
    column :title
    column :start
    column :ending
    column :species
    column :user

    default_actions
  end

  form do |f| 
    f.inputs do
      f.input :code
      f.input :name
      f.input :title
      f.input :description
      f.input :start
      f.input :ending
      f.input :species, :as => :select, :collection => Study.all.map(&:species).select(&:present?).uniq.append("Many").append("N/A")
      f.input :user, :label => "Owner"
      f.has_many :collaborators do |c|
        c.inputs "Collaborators" do
          c.input :user
          c.input :role, :as => :select, :collection => Collaborator::ROLES.map{|r|["#{r.humanize} - #{Collaborator::ROLE_MAP[r.to_sym]}",r]}
          if !c.object.nil?
            c.input :_destroy, :as => :boolean, :label => "Destroy?"
          end
        end
      end
      f.input :img_first, :hint => (f.template.image_tag(f.object.img_first.url(:thumb)) unless f.object.img_first.blank?)
      f.input :img_second, :hint => (f.template.image_tag(f.object.img_second.url(:thumb)) unless f.object.img_second.blank?)
      f.input :img_third, :hint => (f.template.image_tag(f.object.img_third.url(:thumb)) unless f.object.img_third.blank?)
      f.input :img_fourth, :hint => (f.template.image_tag(f.object.img_fourth.url(:thumb)) unless f.object.img_fourth.blank?)
      f.input :img_fifth, :hint => (f.template.image_tag(f.object.img_fifth.url(:thumb)) unless f.object.img_fifth.blank?)
    end
    f.actions
  end

  show do |s|
    attributes_table do
      row :code
      row :name
      row :title
      row :description
      row :start
      row :ending
      row :species
      row :user
    end

    panel "Collaborators" do
      table_for s.collaborators do
        column :user
      end
    end

    panel "Images" do
      div do
        image_tag(s.img_first.url(:thumb)) unless s.img_first.blank?
      end
      div do
        image_tag(s.img_second.url(:thumb)) unless s.img_second.blank?
      end
      div do
        image_tag(s.img_third.url(:thumb)) unless s.img_third.blank?
      end
      div do
        image_tag(s.img_fourth.url(:thumb)) unless s.img_fourth.blank?
      end
      div do
        image_tag(s.img_fifth.url(:thumb)) unless s.img_fifth.blank?
      end
    end
      
    active_admin_comments
  end

end
