class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, presence: true,
    length: {maximum: Settings.microposts.content_length}
  validate  :picture_size
  validates :user_id, presence: true
  mount_uploader :picture, PictureUploader
  scope :order_created, ->{order(created_at: :desc)}

  private

  def picture_size
    return if picture.size <= Settings.microposts.max_size.megabytes

    errors.add(:picture, I18n.t("message.micropost.max_size"))
  end
end
