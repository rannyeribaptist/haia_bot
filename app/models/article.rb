class Article < ApplicationRecord
  belongs_to :legislation

  has_many :comments
  accepts_nested_attributes_for :comments, :allow_destroy => true

  before_save :insert_br

  def insert_br
    self.content.gsub("         ", "\n")
  end
end
