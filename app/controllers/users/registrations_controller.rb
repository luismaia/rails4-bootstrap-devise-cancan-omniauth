class Users::RegistrationsController < Devise::RegistrationsController

  respond_to :html, :json

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

    if omniauth
      @user.from_omniauth(omniauth)
    else
      @user.provider = 'local'
    end

    @user
  end


  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :identity_id,
                                 :password, :password_confirmation, :current_password, :genders => [])
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                 :password, :password_confirmation, :current_password, :genders => [])
  end

  private :sign_up_params
  private :account_update_params
end