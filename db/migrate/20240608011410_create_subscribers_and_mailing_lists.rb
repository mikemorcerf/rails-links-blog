class CreateSubscribersAndMailingLists < ActiveRecord::Migration[7.1]
  def change
    create_table :subscribers do |t|
      t.string :email, null: false

      t.timestamps
    end

    add_index :subscribers, :email, unique: true

    create_table :mailing_lists do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :mailing_lists, :name, unique: true

    create_table :mailing_lists_subscribers, id: false do |t|
      t.belongs_to :subscriber
      t.belongs_to :mailing_list
    end
  end
end
