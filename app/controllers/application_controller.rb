class ApplicationController < ActionController::Base
  protect_from_forgery

  # Rescue from permission error
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
    
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def authenticate_admin_user!
    unless can? :read, ActiveAdmin
      flash[:error] = "Permission Denied"
      redirect_to root_path
    end
  end

end
