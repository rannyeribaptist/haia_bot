class Article < ApplicationRecord
  belongs_to :legislation

  has_many :comments
  accepts_nested_attributes_for :comments, :allow_destroy => true

  before_save :insert_br

  def insert_br
    self.content.gsub("         ", "\n")
  end

  filterrific(
   default_filter_params: { sorted_by: 'content_asc' },
   available_filters: [
     :sorted_by,
     :legislation,
     :search_query
   ]
 )

 scope :legislation, -> legislation_id { where(:legislation_id => legislation_id) }

 scope :search_query, lambda { |query|
    where("content LIKE ?", "%#{query}%")
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^content/
      order("LOWER(articles.content) #{ direction }")        
    else
      raise(ArgumentError, "Opção inválida: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Nome (a-z)', 'name_asc']      
    ]
  end
end
