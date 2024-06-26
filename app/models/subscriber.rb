# frozen_string_literal: true

class Subscriber < ApplicationRecord
  has_many :mailing_lists_subscribers
  has_many :mailing_lists, through: :mailing_lists_subscribers

  validates :email, uniqueness: true, presence: true
end
