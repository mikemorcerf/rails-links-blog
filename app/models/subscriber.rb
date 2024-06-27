# frozen_string_literal: true

class Subscriber < ApplicationRecord
  has_many :mailing_lists_subscribers, dependent: :destroy
  has_many :mailing_lists, through: :mailing_lists_subscribers

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
