class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :links do |t|
      t.string :url
      t.string :icon
      t.integer :order, null: false
      t.boolean :display, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :links, :order, unique: true
  end
end
