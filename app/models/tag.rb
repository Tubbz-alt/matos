class Tag < ActiveRecord::Base
  include PgSearch

  pg_search_scope :search_all,
                  :against => [:serial, :code, :code_space, :model, :manufacturer, :description],
                  :using => {
                    :tsearch => {:prefix => true},
                    :trigram => {}
                  }

  pg_search_scope :exact_match,
                  :against => [:serial, :code, :code_space],
                  :using => {
                    :tsearch => {:any_word => true}
                  }

  has_many   :tag_deployments, :dependent => :destroy, :order => "release_date DESC"
  belongs_to :active_deployment, :class_name => TagDeployment

  validates_uniqueness_of   :code, :scope => :code_space, :case_sensitive => false

  validates_presence_of     :code, :code_space

  self.inheritance_column = 'none'

  scope :find_match, lambda { |code| where("((code_space || '-' || code) ILIKE ?) OR (code ILIKE ?) OR (code_space ILIKE ?)", "%#{code}%","%#{code}%","%#{code}%").limit(1) }
  scope :find_all_matches, lambda { |code| where("((code_space || '-' || code) ILIKE ?) OR (code ILIKE ?) OR (code_space ILIKE ?)", "%#{code}%","%#{code}%","%#{code}%") }

  scope :readable, lambda {|u| includes({ :tag_deployments => {:study => {:collaborators => :user}}}).where("active_deployment_id is NULL OR (users.role = 'admin' OR studies.user_id = #{u.id} OR users.id = #{u.id})") }

  def active_deployment_json
    begin
      return active_deployment.as_json({
        :include => {
          :study => {
            :only => [:id, :name],
            :include => {:user => {
              :only => [:name, :email]
            }}
          }
        },
        :only => [:release_date, :release_location, :external_codes, :length, :weight, :age, :sex, :common_name]
      })
    rescue
      return TagDeployment.new.as_json({:only => [:release_date, :release_location, :external_codes, :length, :weight, :age, :sex, :common_name]})
    end
  end

  def unmatched_hits
    Hit.where("tag_code = '#{self.to_label}' AND tag_deployment_id IS NULL")
  end

  def model=(model)
    write_attribute(:model,(model.downcase rescue nil))
  end

  def type=(type)
    write_attribute(:type,(type.downcase rescue nil))
  end
  
  def manufacturer=(manufacturer)
    write_attribute(:manufacturer,(manufacturer.downcase rescue nil))
  end

  def serial=(serial)
    write_attribute(:serial,(serial.downcase rescue nil))
  end

  def to_label
    "#{code_space}-#{code}"
  end

  def display_name
    "#{code_space}-#{code}"
  end

end

# ## Schema Information
# Schema version: 20130311180440
#
# Table name: tags
#
# Field                     | Type               | Attributes
# ------------------------- | ------------------ | -------------------------
# **id                   ** | `integer         ` | `not null, primary key`
# **serial               ** | `string(255)     ` | ``
# **code                 ** | `string(255)     ` | ``
# **code_space           ** | `string(255)     ` | ``
# **lifespan             ** | `string(255)     ` | ``
# **endoflife            ** | `datetime        ` | ``
# **model                ** | `string(255)     ` | ``
# **manufacturer         ** | `string(255)     ` | ``
# **type                 ** | `string(255)     ` | ``
# **description          ** | `text            ` | ``
# **active_deployment_id ** | `integer         ` | ``
#
# Indexes
#
#  index_tags_on_model  (model)
#

