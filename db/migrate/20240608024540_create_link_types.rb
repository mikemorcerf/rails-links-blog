# frozen_string_literal: true

class CreateLinkTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :link_types do |t|
      t.string :name
      t.references :link, null: false, foreign_key: true

      t.timestamps
    end
  end
end
