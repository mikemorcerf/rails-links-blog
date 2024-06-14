class Link < ApplicationRecord
  belongs_to :user
  has_one :link_type

  validates :order, :user_id, presence: true
  validates :display, inclusion: { in: [true, false] }

  default_scope { order(order: :asc) }
  scope :visible, -> { where(display: true) }
end
