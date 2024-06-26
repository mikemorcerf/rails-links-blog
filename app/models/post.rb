# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :posts_tags, dependent: :destroy
  has_many :tags, through: :posts_tags
  has_rich_text :body

  validates :deliver_newsletter, inclusion: { in: [true, false] }
  validates :title, presence: true
  validates :static_page_name, presence: true, uniqueness: true
  validates :title, presence: true

  before_validation :create_static_page_name

  def to_param
    static_page_name
  end

  private

  def create_static_page_name
    self.static_page_name = title&.parameterize
  end
end
