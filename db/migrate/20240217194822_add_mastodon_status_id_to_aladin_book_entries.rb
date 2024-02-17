class AddMastodonStatusIdToAladinBookEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :aladin_book_entries, :mastodon_status_id, :string
    add_index :aladin_book_entries, :mastodon_status_id
  end
end
