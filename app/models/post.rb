class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: :user_id, class_name: User
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, uniqueness: true, length: { minimum: 5 }
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true

  before_save :add_slug

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def add_slug
    self.slug = self.title.gsub(/[ \W]/, ' ' => "-", '\W' => "").downcase
  end

  def to_param
    slug
  end
end