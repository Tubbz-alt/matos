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
      d.study.permissions == 'public' || d.study.collaborators.map(&:user).include?(@user)
    end
    can :manage, Deployment, Deployment.includes({ :study => :collaborators }) do |d|
      d.study.user_id == @user.id || d.study.collaborators.select({ :role => 'manage' }).map(&:user).include?(@user)
    end

    # Tag
    can :read, Tag, Tag.includes({ :study => :collaborators }) do |t|
      t.study.permissions == 'public' || t.study.collaborators.map(&:user).include?(@user)
    end
    can :manage, Tag, Tag.includes({ :study => :collaborators }) do |t|
      t.study.user_id == @user.id || t.study.collaborators.select({ :role => 'manage' }).map(&:user).include?(@user)
    end

    can :read, Study
    can :manage, Study, Study.includes(:collaborators) do |s|
      s.user_id == @user.id || s.collaborators.select({ :role => 'manage' }).map(&:user).include?(@user)
    end
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
