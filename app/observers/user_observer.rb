class UserObserver < ActiveRecord::Observer

  def before_save(user)
    if user.requested_role_changed?
      # If the requested role is being upgraded, require an approval
      old_role = User::ROLES.index(user.requested_role_was) || User::ROLES.index('general')
      # Make sure this isn't a 'create' to avoid duplicate emails.
      if !user.requested_role.blank?
        if old_role < User::ROLES.index(user.requested_role) && User.exists?(user.id)
          UserMailer.request_role(user).deliver
        else
          user.role = user.requested_role
        end
      end
    elsif user.approved_changed? && user.approved && User.exists?(user.id)
      UserMailer.account_approved(user).deliver
    end

  end

  def after_create(user)
    if user.role == 'general'
      user.approve!
    else
      UserMailer.new_account(user).deliver
    end
  end
end
