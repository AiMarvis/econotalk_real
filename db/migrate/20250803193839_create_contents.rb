class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.string :title
      t.text :body
      t.string :link
      t.integer :content_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
