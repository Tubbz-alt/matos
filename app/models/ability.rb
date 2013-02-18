class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new(:role => :guest) # for guest
    send(@user.role)
  end

  def guest
    can :create, Report
  end

  def general
    guest
    can :manage, User, :id => @user.id
    can :read, Deployment
  end

  def researcher
    general
    can :read, Report
  end

  def investigator
    researcher
    can :create, Study # For data submission
    can :create, User # For data submission
    can :manage, Study, :user_id => @user.id
    can :manage, Tag, :study => { :user_id => @user.id }
    can :manage, Deployment, :study => { :user_id => @user.id }
    can :create, Submission
    can :read,   Submission, :user_id => @user.id
    can :read,   ActiveAdmin
  end

  def admin
    can :manage, :all
  end

end
