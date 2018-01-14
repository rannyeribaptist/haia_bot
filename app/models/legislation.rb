class Legislation < ApplicationRecord
  has_many :articles, dependent: :destroy
  accepts_nested_attributes_for :articles
end
