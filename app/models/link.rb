# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :user
  has_one :link_type

  validates :display, inclusion: { in: [true, false] }
  validates :order, :user_id, presence: true

  default_scope { order(order: :asc) }
  scope :visible, -> { where(display: true) }

  before_create :reorder_links_before_create
  before_destroy :reorder_links_before_destroy

  private

  def reorder_links_before_create
    ActiveRecord::Base.transaction do
      Link.all.find_each do |link|
        link.increment!(:order)
      end
    end
  end

  def reorder_links_before_destroy
    ActiveRecord::Base.transaction do
      Link.where(order: (order + 1)..).each do |link|
        link.decrement!(:order)
      end
    end
  end
end
