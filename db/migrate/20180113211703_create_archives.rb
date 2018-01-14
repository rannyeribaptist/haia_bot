class CreateArchives < ActiveRecord::Migration[5.1]
  def change
    create_table :archives do |t|
      t.text :archive

      t.timestamps
    end
  end
end
