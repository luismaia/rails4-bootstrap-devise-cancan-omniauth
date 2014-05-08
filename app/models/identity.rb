class Identity < ActiveRecord::Base

  belongs_to :user, :foreign_key => "user_id"


  def self.from_omniauth(auth)
    identity = where(auth.slice(:provider, :uid)).first_or_create do |identity|
      identity.provider = auth.provider
      identity.uid = auth.uid
      identity.token = auth.credentials.token
      identity.secret = auth.credentials.secret if auth.credentials.secret
      identity.expires_at = auth.credentials.expires_at if auth.credentials.expires_at
      identity.email = auth.info.email if auth.info.email
      identity.image = auth.info.image if auth.info.image

      identity.nickname = auth.info.nickname
      identity.nickname = auth.info.username if identity.nickname.blank?

      identity.name = auth.info.name if auth.info.name
      identity.first_name = auth.info.first_name
      identity.last_name = auth.info.last_name
      identity.gender = auth.extra.raw_info.gender
      identity.birthday = DateTime.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y")
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

      self.user.set_gender(self.gender)
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
          genders: [self.gender]
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
