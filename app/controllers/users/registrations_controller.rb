class Users::RegistrationsController < Devise::RegistrationsController

  respond_to :html, :json

  def new
    # Clean session[:omniauth] variable
    # if the user logins and accepts provider access, but doesn't complete the registration
    if session[:omniauth_provider].blank?
      session[:omniauth] = nil
    else
      session[:omniauth_provider] = nil
    end

    super
  end

  def create
    omniauth = session[:omniauth]

    if omniauth
      user = build_resource
      user.assign_attributes(sign_up_params)

      identity = Identity.where(provider: omniauth[:provider], uid: omniauth[:uid]).first
      identity.user = identity.find_or_create_user(user)

      session[:omniauth] = nil

      set_flash_message :notice, :signed_up if is_flashing_format?
      sign_in(identity.user)
      respond_with resource, location: after_sign_up_path_for(resource)

    else
      # If omniauth is not set execute default Devise create action
      super
    end
  end


  def build_resource(*args)
    super
    omniauth = session[:omniauth]
    @user.from_omniauth(omniauth)
    @user
  end


  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :identity_id,
                                 :password, :password_confirmation, :current_password, :gender)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                 :password, :password_confirmation, :current_password, :gender)
  end

  private :sign_up_params
  private :account_update_params
end