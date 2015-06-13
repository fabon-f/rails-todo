class User < ActiveRecord::Base
  has_many :tasks

  before_save do
    self.email.downcase!
    self.username.downcase!
  end

  authenticates_with_sorcery!

  validates :password, confirmation: true, length: { minimum: 8 }, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :username, uniqueness: { case_sensitive: false }, format: { with: /\A\w+\z/i }

  def to_param
    username
  end

  def correct_password?(password)
    User.authenticate(self.email, password) == self
  end
end
