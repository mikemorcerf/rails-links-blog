class MailingList < ApplicationRecord
  has_and_belongs_to_many :subscribers

  validates :name, uniqueness: true, presence: true

  scope :post_newsletter_subscribers, -> { find_by_name('post_newsletter').subscribers }
end
