module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :add_slug
    class_attribute :slug_column
  end

  def add_slug
    a_slug = prepare_slug(self.send(self.class.slug_column.to_sym))
    obj = self.class.find_by(slug: a_slug)
    count = 1
    while obj && obj != self
      a_slug = append_suffix(a_slug, count)
      obj = self.class.find_by(slug: a_slug)
      count += 1
    end
    self.slug = a_slug
  end

  def prepare_slug(str)
    str = str.strip.downcase
    str.gsub!(/[ \W]/, ' ' => "-", '\W' => "")
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

  module ClassMethods
    def sluggable_column(col)
      self.slug_column = col
    end
  end
end