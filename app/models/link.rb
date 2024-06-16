class Link < ApplicationRecord
  belongs_to :user
  has_one :link_type

  validates :order, :user_id, presence: true
  validates :display, inclusion: { in: [true, false] }

  default_scope { order(order: :asc) }
  scope :visible, -> { where(display: true) }

  before_create :reorder_links_after_create
  before_destroy :reorder_links_after_destroy

  private

  def reorder_links_after_create
    order = 1
    ActiveRecord::Base.transaction do
      Link.all.each do |link|
        link.increment!(:order)
      end
    end
  end

  def reorder_links_after_destroy
    ActiveRecord::Base.transaction do
      Link.where(order: (self.order+1)..).each do |link|
        link.decrement!(:order)
      end
    end
  end
end
