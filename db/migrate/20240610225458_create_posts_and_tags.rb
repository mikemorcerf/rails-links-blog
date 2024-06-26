# frozen_string_literal: true

class CreatePostsAndTags < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :static_page_name, null: false
      t.string :video_url
      t.boolean :deliver_newsletter, null: false, default: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :posts, :static_page_name, unique: true

    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :posts_tags, id: false do |t|
      t.belongs_to :post
      t.belongs_to :tag
    end
  end
end
