class Task < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :title, length: { maximum: 150 }
  validates :description, length: { maximum: 10000 }
end
