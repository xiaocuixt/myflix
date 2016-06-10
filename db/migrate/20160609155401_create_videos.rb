class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :small_cover_url
      t.string :large_cover_url
      t.string :cover_image_url
      t.integer :category_id
      t.text :description

      t.timestamps
    end
  end
end
