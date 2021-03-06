class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_communities

  def find_model
    params.each do |name, value|
      if name =~ /(.+)_id\z/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  protected

    def set_communities
      if user_signed_in?
        @communities = current_user.subscriptions
      else
        @communities = Sub.all
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
    end
end
