class User < ActiveRecord::Base
  before_save { self.email.downcase! }

  authenticates_with_sorcery!
  validates :password, confirmation: true, length: { minimum: 8 }, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
end
