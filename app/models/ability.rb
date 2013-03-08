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
    cannot :destroy, User

    # Deployment
    can :read, Deployment, Deployment.includes({ :study => :collaborators }) do |d|
      d.study.collaborators.map(&:user_id).include?(@user.id)
    end
    can :manage, Deployment, Deployment.includes(:study) do |d|
      d.study.user_id == @user.id
    end
    can :manage, Deployment, Deployment.includes({ :study => :collaborators }) do |d|
      d.study.collaborators.select({ :role => 'manage' }).map(&:user_id).include?(@user.id)
    end

    # Tag
    can :read, Tag, Tag.includes({ :study => :collaborators }) do |d|
      d.study.collaborators.map(&:user_id).include?(@user.id)
    end
    can :manage, Tag, Tag.includes(:study) do |d|
      d.study.user_id == @user.id
    end
    can :manage, Tag, Tag.includes({ :study => :collaborators }) do |d|
      d.study.collaborators.select({ :role => 'manage' }).map(&:user_id).include?(@user.id)
    end

    can :manage, Study, :user_id => @user.id
    cannot :destroy, Study

  end

  def researcher
    general
    can :read, Report
  end

  def investigator
    researcher
    can :create, Submission
    can :read,   Submission, :user_id => @user.id
    can :read,   ActiveAdmin
  end

  def admin
    can :manage, :all
  end

end
