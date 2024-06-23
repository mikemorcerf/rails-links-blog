# frozen_string_literal: true

class MailingList < ApplicationRecord
  has_and_belongs_to_many :subscribers

  validates :name, uniqueness: true, presence: true

  scope :post_newsletter_subscribers, -> { find_by(name: 'post_newsletter').subscribers }
end
