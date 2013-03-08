class Collaborator < ActiveRecord::Base

  belongs_to :user
  belongs_to :study

  ROLES = %w[view manage]
  ROLE_MAP = {
    :view => "Read permissions",
    :manage => "Read/Write permissions"
  }

  validates_presence_of     :user_id, :study_id, :role
  validates_uniqueness_of   :user_id, :scope => :study_id
  validates :role, :inclusion => { :in => ROLES, :message => "%{value} is not a valid role" }

end