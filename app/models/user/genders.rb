module User::Genders
  extend ActiveSupport::Concern

  included do
  end

  def genders=(gender)
    self.gender = gender
  end

  # def genders=(genders)
  #   self.genders_mask = (genders & AppConfig.genders).map { |r| 2**AppConfig.genders.index(r) }.inject(0, :+)
  # end
  #
  # def genders
  #   AppConfig.genders.reject do |r|
  #     ((genders_mask || 0) & 2**AppConfig.genders.index(r)).zero?
  #   end
  # end
  #
  # def has_gender?(gender)
  #   genders.include?(gender.to_s)
  # end
  #
  # # Genders Inheritance
  # def genders?(base_gender)
  #   AppConfig.genders.index(base_gender.to_s) <= AppConfig.genders.index(gender)
  # end
end
