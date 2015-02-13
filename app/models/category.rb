class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true

  before_save :add_slug

  def add_slug
    self.slug = self.name.gsub(/[ \W]/, ' ' => "-", '\W' => "").downcase
  end

  def to_param
    slug
  end
end