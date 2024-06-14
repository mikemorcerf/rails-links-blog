class Post < ApplicationRecord
  has_and_belongs_to_many :tags
  belongs_to :user

  has_rich_text :body

  validates :title, presence: true
end
