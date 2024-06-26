# frozen_string_literal: true

class LinkType < ApplicationRecord
  has_many :links, dependent: :nullify
end
