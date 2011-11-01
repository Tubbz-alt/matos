class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :organization, :password, :password_confirmation, :remember_me, :role, :requested_role, :approved

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :email, :case_sensitive => false

  ROLES = %w[guest public researcher investigator admin]
  REGISTERABLE_ROLES = ROLES - %w[guest]
  ROLE_MAP = {
    :guest => "Unregistered visitor to the site",
    :public => "Registered user of the GLATOS website",
    :researcher => "Researcher interested in GLATOS data",
    :investigator => "Contributor to the GLATOS database",
    :admin => "Administrator of the GLATOS website"
  }

  def DT_RowId
    self.id
  end

  def approve!
    self.approved = true
    self.save!
  end

  # Accounts need to be approved
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      I18n.t("devise.failure.not_approved")
    else
      super # Use whatever other message
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved? && recoverable.errors.blank?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

end
