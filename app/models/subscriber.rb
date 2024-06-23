# frozen_string_literal: true

class Subscriber < ApplicationRecord
  has_and_belongs_to_many :mailing_lists

  validates :email, uniqueness: true, presence: true
end
