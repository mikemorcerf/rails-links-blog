# frozen_string_literal: true

class Subscriber < ApplicationRecord
  has_many :mailing_lists_subscribers, dependent: :destroy
  has_many :mailing_lists, through: :mailing_lists_subscribers

  validates :email, uniqueness: true, presence: true
end
