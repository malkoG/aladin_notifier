class CreateUrlAliases < ActiveRecord::Migration[7.1]
  def change
    create_table :url_aliases do |t|
      t.string :short
      t.string :long

      t.timestamps
    end
    add_index :url_aliases, :short, unique: true
    add_index :url_aliases, :long, unique: true
  end
end
