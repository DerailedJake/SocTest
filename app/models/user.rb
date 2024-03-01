class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_one_attached :avatar
  has_many :stories, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :first_name, presence: true, length: { minimum: 1, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 20 }
  validates :description, length: { minimum: 1, maximum: 240 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
