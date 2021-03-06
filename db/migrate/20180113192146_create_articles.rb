class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.text :content
      t.belongs_to :legislation, foreign_key: true
      t.string :number

      t.timestamps
    end
  end
end
