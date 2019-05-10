class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :idol, class_name: User.name

  validates :follower_id, presence: true
  validates :idol_id, presence: true
end
