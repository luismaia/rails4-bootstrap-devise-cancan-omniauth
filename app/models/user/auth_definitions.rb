module User::AuthDefinitions
  extend ActiveSupport::Concern

  included do

    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable, :lockable, :omniauthable


    # new function to determine whether a password has been set
    def has_no_password?
      self.encrypted_password.blank? || (self.uid && self.provider)
    end


    # Password not required when using omniauth
    def password_required?
      super
    end


    # Confirmation not required when using omniauth
    def confirmation_required?
      super
    end


    def update_with_password(params, *options)
      if encrypted_password.blank?
        update_attributes(params, *options)
      else
        super
      end
    end


    def from_omniauth(omniauth)
      self.provider = omniauth['provider'] if self.provider.blank?
      self.uid = omniauth['uid'] if self.uid.blank?

      self.email = omniauth['info']['email'] if self.email.blank?

      self.name = omniauth["info"]["name"] if self.name.blank?

      self.first_name = omniauth["info"]["first_name"] if self.first_name.blank?
      self.first_name = omniauth["info"]["name"] if self.first_name.blank?

      self.last_name = omniauth["info"]["last_name"] if self.last_name.blank?

      self.nickname = omniauth["info"]["nickname"] if self.nickname.blank?
      self.nickname = omniauth["info"]["username"] if self.nickname.blank?

      self.genders_mask = omniauth["extra"]["raw_info"]["gender"].to_a if self.genders_mask.blank?
      self.birthday = omniauth["extra"]["raw_info"]["birthday"].to_a if self.birthday.blank?
    end

  end
end