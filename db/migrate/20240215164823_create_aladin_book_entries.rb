class CreateAladinBookEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :aladin_book_entries do |t|
      t.string :published_at

      t.string :item_id
      t.string :isbn
      t.string :isbn13

      t.string :title
      t.string :link
      t.string :author 
      t.string :publisher

      t.text :description

      t.timestamps
    end
    add_index :aladin_book_entries, :item_id
    add_index :aladin_book_entries, :isbn
    add_index :aladin_book_entries, :isbn13
  end
end
