# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :link_type, optional: true
  belongs_to :user

  validates :display, inclusion: { in: [true, false] }
  validates :order, presence: true

  default_scope { order(order: :asc) }
  scope :visible, -> { where(display: true) }

  before_create :reorder_links_before_create
  before_destroy :reorder_links_before_destroy

  private

  def reorder_links_before_create
    ActiveRecord::Base.transaction do
      Link.find_each do |link|
        link.order += 1
        link.save
      end
    end
  end

  def reorder_links_before_destroy
    ActiveRecord::Base.transaction do
      Link.where(order: (order + 1)..).each do |link|
        link.order -= 1
        link.save
      end
    end
  end
end
