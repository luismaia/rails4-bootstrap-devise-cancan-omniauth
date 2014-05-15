class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  include User::AuthDefinitions
  include User::Genders

  has_one :identity

  has_and_belongs_to_many :roles, join_table: :users_roles
  accepts_nested_attributes_for :roles, allow_destroy: false

  validates_associated :roles
  validates_presence_of :email, :first_name, :last_name

  validates_uniqueness_of :email, case_sensitive: false, scope: :provider
  validates :email, length: {minimum: 7, maximum: 50}
  validates_format_of :email, with: /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i,
                      allow_blank: true,
                      message: I18n.t("model.messages.emailError")


  def full_name
    "#{first_name} #{last_name}"
  end


  # GENDER
  def self.get_gender(gender)
    if AppConfig.genders.to_a.include? gender
      gender
    else
      AppConfig.default_gender
    end
  end

  def set_gender(gender)
    self.gender = User.get_gender(gender)
  end


  # ROLE
  def set_def_role
    role = Role.find_by_flg_default(1)
    self.add_role role.name
  end

  def get_user_roles_id
    user_roles = self.roles.collect { |i| i.id }
  end

  def get_user_roles_name
    user_roles = self.roles.collect { |i| i.name }
    user_roles.join(", ") unless self.roles.first.nil?
  end

end
