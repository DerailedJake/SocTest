class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :create_notification_manager
  has_many :posts, dependent: :destroy
  has_many :contacts
  has_many :acquaintances, through: :contacts
  has_many :messages
  has_many :chat_participations, dependent: :destroy
  has_many :chats, through: :chat_participations
  has_one :notification_manager, dependent: :destroy
  has_many :notifications, through: :notification_manager
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200], preprocessed: true
  end
  has_many :stories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :first_name, presence: true, length: { minimum: 1, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 20 }
  validates :avatar, presence: true
  validates :description, length: { maximum: 240 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
