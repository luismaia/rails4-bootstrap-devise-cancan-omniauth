class Users::RegistrationsController < Devise::RegistrationsController

  respond_to :html, :json

  def create
    super

    omniauth = session[:omniauth]

    if omniauth
      identity = Identity.where(provider: omniauth['provider'], uid: omniauth['uid']).first
      identity.user = resource
      identity.save

      session[:omniauth] = nil
    end
  end

  def build_resource(*args)
    super

    omniauth = session[:omniauth]

    if omniauth
      identity = Identity.where(provider: omniauth['provider'], uid: omniauth['uid']).first

      #@user.apply_omniauth(session[:omniauth], person)
      @user.email = identity.email unless identity.email.nil?
      @user.first_name = identity.first_name unless identity.first_name.nil?
      @user.last_name = identity.last_name unless identity.last_name.nil?
      @user.provider = identity.provider unless identity.provider.nil?
      @user.uid = identity.uid unless identity.uid.nil?
      @user.roles = [AppConfig.default_role]

      @user.password = '123456789'
    end
  end


  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :identity_id, :password, :password_confirmation, :current_password)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

  private :sign_up_params
  private :account_update_params
end