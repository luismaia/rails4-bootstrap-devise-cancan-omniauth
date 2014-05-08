class Users::PasswordsController < Devise::PasswordsController

  def resource_params
    params.require(:user).permit(:email, :provider, :reset_password_token, :password, :password_confirmation)
  end

  private :resource_params
end