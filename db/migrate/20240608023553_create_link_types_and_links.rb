# frozen_string_literal: true

class CreateLinkTypesAndLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :link_types do |t|
      t.string :name

      t.timestamps
    end

    create_table :links do |t|
      t.string :title
      t.string :url
      t.string :icon
      t.integer :order, null: false, default: 1
      t.boolean :display, null: false, default: false
      t.references :user, null: false, foreign_key: true
      t.references :link_type, null: true, foreign_key: true

      t.timestamps
    end
  end
end
