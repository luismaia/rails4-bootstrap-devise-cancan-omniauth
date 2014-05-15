class Identity < ActiveRecord::Base

  belongs_to :user, :foreign_key => "user_id"


  def self.from_omniauth(omniauth)
    identity = where(omniauth.slice(:provider, :uid)).first_or_create do |identity|
      identity.provider = omniauth.provider
      identity.uid = omniauth.uid

      if omniauth.info
        identity.email = omniauth.info.email if omniauth.info.email
        identity.name = omniauth.info.name if omniauth.info.name
        identity.first_name = omniauth.info.first_name if omniauth.info.first_name
        identity.last_name = omniauth.info.last_name if omniauth.info.last_name

        identity.nickname = omniauth.info.nickname if omniauth.info.nickname
        identity.nickname ||= omniauth.info.username if omniauth.info.username

        identity.token = omniauth.credentials.token
        identity.secret = omniauth.credentials.secret if omniauth.credentials.secret
        identity.expires_at = omniauth.credentials.expires_at if omniauth.credentials.expires_at
        identity.image = omniauth.info.image if omniauth.info.image
      end

      if omniauth.extra
        if omniauth.extra.raw_info
          identity.gender = omniauth.extra.raw_info.gender if omniauth.extra.raw_info.gender
          identity.birthday = DateTime.strptime(omniauth.extra.raw_info.birthday, "%m/%d/%Y") if omniauth.extra.raw_info.birthday
        end
      end

    end
    identity.save!

    if !identity.persisted?
      redirect_to root_url, alert: "Something went wrong, please try again."
    end
    identity
  end


  def find_or_create_user(current_user)
    if current_user && self.user == current_user
      # User logged in and the identity is associated with the current user
      return self.user
    elsif current_user && self.user != current_user
      # User logged in and the identity is not associated with the current user
      # so lets associate the identity and update missing info
      self.user = current_user
      Rails.logger.info "This is user with updating identity #{self.user} PT2 #{self.inspect} PT3 #{self.user.inspect}"
      self.user.email       ||= self.email
      self.user.name        ||= self.name
      self.user.nickname    ||= self.nickname
      self.user.first_name  ||= self.first_name
      self.user.last_name   ||= self.last_name
      self.user.uid         ||= self.uid
      self.user.provider    ||= self.provider
      self.user.birthday    ||= self.birthday

      self.user.set_gender(self.user.gender)
      self.user.set_def_role #Default role association

      self.user.skip_confirmation!
      self.user.skip_reconfirmation!
      self.user.save!(validate: false)
      self.user_id ||= self.user.id
      self.save!
      return self.user
    elsif self.user.present?
      # User not logged in and we found the identity associated with user
      # so let's just log them in here
      return self.user
    else
      # No user associated with the identity so we need to create a new one
      Rails.logger.info "This is a new user not associated with identity #{self.inspect}"
      self.build_user(
          email: self.email,
          name: self.name,
          nickname: self.nickname,
          first_name: self.first_name,
          last_name: self.last_name,
          uid: self.uid,
          birthday: self.birthday,
          provider: self.provider,
          genders: User.get_gender(self.gender)
      )
      self.user.set_def_role #Default role association
      self.user.skip_confirmation!
      self.user.save!(validate: false)
      self.user_id ||= self.user.id
      self.save!
      return self.user
    end
  end


  def create_user
  end
end
