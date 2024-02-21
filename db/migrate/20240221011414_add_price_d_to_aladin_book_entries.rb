class AddPriceDToAladinBookEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :aladin_book_entries, :price, :integer, default: 0
  end
end
