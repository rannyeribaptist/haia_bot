class AddCommentsToArchives < ActiveRecord::Migration[5.1]
  def change
    add_column :archives, :is_comment, :boolean
  end
end
