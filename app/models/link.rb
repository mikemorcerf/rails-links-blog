class Link < ApplicationRecord
  belongs_to :user
  has_one :link_type
end
