class User < ActiveRecord::Base
  has_many :tasks, dependent: :destroy

  before_save do
    email.downcase!
    username.downcase!
  end

  authenticates_with_sorcery!

  validates :password, confirmation: true, length: { minimum: 8 }, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :username, uniqueness: { case_sensitive: false }, format: { with: /\A\w+\z/i }

  validates :role, inclusion: { in: %w(user admin) }

  def to_param
    username
  end

  def admin?
    role == 'admin'
  end

  def correct_password?(password)
    User.authenticate(email, password) == self
  end
end
