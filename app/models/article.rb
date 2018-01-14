class Article < ApplicationRecord
  belongs_to :legislation

  before_save :insert_br

  def insert_br
    self.content.gsub("         ", "\n")
  end
end
