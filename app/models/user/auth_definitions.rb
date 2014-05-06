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
      super && identities.empty?
    end

    # Confirmation not required when using omniauth
    def confirmation_required?
      super && identities.empty?
    end

    def update_with_password(params, *options)
      if encrypted_password.blank?
        update_attributes(params, *options)
      else
        super
      end
    end



    # def self.new_with_session(params, session)
    #   if session["devise.user_attributes"]
    #     new(session["devise.user_attributes"], without_protection: true) do |user|
    #       user.attributes = params
    #       user.valid?
    #     end
    #   else
    #     super
    #   end
    # end

  end
end