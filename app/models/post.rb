class Post < ApplicationRecord
  has_and_belongs_to_many :tags
  belongs_to :user

  has_rich_text :body

  validates :title, :static_page_name, presence: true, uniqueness: true
  validates :deliver_newsletter, inclusion: { in: [true, false] }

  before_validation :create_static_page_name

  def to_param
    static_page_name
  end

  private

  def create_static_page_name
    self.static_page_name = title.parameterize
  end
end
