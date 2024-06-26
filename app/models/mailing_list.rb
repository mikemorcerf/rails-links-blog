# frozen_string_literal: true

class MailingList < ApplicationRecord
  has_many :mailing_lists_subscribers, dependent: :destroy
  has_many :subscribers, through: :mailing_lists_subscribers

  validates :name, uniqueness: true, presence: true

  scope :post_newsletter_subscribers, -> { find_by(name: 'post_newsletter').subscribers }
end
