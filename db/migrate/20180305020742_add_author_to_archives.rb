class AddAuthorToArchives < ActiveRecord::Migration[5.1]
  def change
    add_column :archives, :author, :string
  end
end
