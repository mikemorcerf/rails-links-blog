class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  before_save :is_admin_email?

  has_many :links, dependent: :destroy
  has_many :posts, dependent: :destroy

  private

  def is_admin_email?
    throw "Yu Ain't No Chosen One" if email != ENV.fetch('ADMIN_EMAIL')
    true
  end
end
