class AddLegislationToArchive < ActiveRecord::Migration[5.1]
  def change
    add_column :archives, :kind, :string
  end
end
