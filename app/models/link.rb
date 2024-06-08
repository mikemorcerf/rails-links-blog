class Link < ApplicationRecord
  belongs_to :user
  has_one :link_type

  validates :order, :display, :user_id, presence: true
end
