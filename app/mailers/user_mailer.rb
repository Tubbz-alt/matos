class UserMailer < ActionMailer::Base

  def new_account(user)
    @user = user
    recips = User.where("role = 'admin'").map(&:email)
    mail(:to => recips, :subject => "[#{I18n.t :project_name}] New Account")
  end

  def request_role(user)
    @user = user
    recips = User.where("role = 'admin'").map(&:email)
    mail(:to => recips, :subject => "[#{I18n.t :project_name}] Role Upgrade Request")
  end

  def account_approved(user)
    @user = user
    recips = user.email
    mail(:to => recips, :subject => "[#{I18n.t :project_name}] Account Approved")
  end

end
