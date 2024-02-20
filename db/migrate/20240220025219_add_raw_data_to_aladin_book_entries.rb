class AddRawDataToAladinBookEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :aladin_book_entries, :raw_data, :jsonb
  end
end
