class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :idol
  has_many :microposts, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :idol_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :email, presence: true,
    length: {maximum: Settings.users.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.users.name_length}
  validates :password, presence: true, allow_nil: true,
    length: {minimum: Settings.users.pass_min_length}
  before_create :create_activation_digest
  before_save{email.downcase!}
  scope :activated, ->{where activated: true}
  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
  end

  def password_reset_expired?
    reset_sent_at < Settings.users.pass_expire.hours.ago
  end

  def feed
    Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
      following_ids: following_ids, user_id: id).order_created
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
