class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :remember_token
  validates :email, presence: true,
    length: {maximum: Settings.users.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.users.name_length}
  validates :password, presence: true,
    length: {minimum: Settings.users.pass_min_length}
  before_save{email.downcase!}
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

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
