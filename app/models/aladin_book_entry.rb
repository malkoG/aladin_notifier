class AladinBookEntry < ApplicationRecord
  def self.import(raw_data)
    return if already_exists?(raw_data)

    hash = { 
      item_id: "itemId",
      isbn: 'isbn',
      isbn13: 'isbn13',

      published_at: 'pubDate',
      
      title: 'title',
      link: 'link',
      author: 'author',
      publisher: 'publisher',

      description: 'description'
    }

    options = {}
    hash.each do |key, label|
      value = raw_data[label]
      options[key] = value
    end

    create!(**options)
  end

  def self.already_exists?(raw_data)
    isbn = raw_data['isbn']
    isbn13 = raw_data['isbn13']
    item_id = raw_data['itemId']

    find_by(isbn:).present? ||
      find_by(isbn13:).present? ||
      find_by(item_id:).present?
  end

  def self.ransackable_attributes(auth_object = nil)
    ["author", "created_at", "description", "id", "id_value", "isbn", "isbn13", "item_id", "link", "published_at", "publisher", "title", "updated_at"]
  end
end
