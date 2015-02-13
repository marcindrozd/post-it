class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: :user_id, class_name: User
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: { minimum: 5 }
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
    a_slug = prepare_slug(self.title)
    post = Post.find_by(slug: a_slug)
    count = 1
    while post && post != self
      a_slug = append_suffix(a_slug, count)
      post = Post.find_by(slug: a_slug)
      count += 1
    end
    self.slug = a_slug
  end

  def prepare_slug(str)
    str = str.strip
    str.gsub!(/[ \W]/, ' ' => "-", '\W' => "").downcase
    str
  end

  def append_suffix(str, count)
    if str.split("-").last.to_i != 0
      str.split("-").slice(0...-1).join("-") + "-" + count.to_s
    else
      str + "-" + count.to_s
    end
  end

  def to_param
    slug
  end
end