# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  before_save :admin_email?

  has_many :links, dependent: :destroy
  has_many :posts, dependent: :destroy

  private

  def admin_email?
    raise "Yu Ain't No Chosen One" if email != ENV.fetch('ADMIN_EMAIL')

    true
  end
end
