class AladinBookEntry < ApplicationRecord
  include ActionView::Helpers::NumberHelper

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

      description: 'description',
      price: 'priceStandard'
    }

    options = {}
    hash.each do |key, label|
      value = raw_data[label]
      options[key] = value
    end

    options['raw_data'] = raw_data

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
    ["author", "created_at", "description", "id", "id_value", "isbn", "isbn13", "item_id", "link", "published_at", "publisher", "title", "updated_at", "mastodon_status_id", "price"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def lookup_status
    bearer_token = ENV["MASTODON_ACCESS_TOKEN"]
    client = Mastodon::REST::Client.new(base_url: 'https://social.silicon.moe', bearer_token:)

    client.status(mastodon_status_id)
  end

  def censorable?
    %w[스마트폰 ITQ 정보통신 파워포인트 GTQ 활용능력 정보처리기사 산업기사 기능사].map { title.include?(_1) }.any?
  end

  def send_notification!
    text = <<~EOF
      #{title} (#{author} / #{publisher} / #{published_at} / #{number_with_delimiter(price)}원) #{link}
    EOF

    _send_mastodon_notification!(text)
    _send_telegram_notification!(text)
  end

  private 

  def _send_telegram_notification!(text)
    Bots::TelegramBot.send_message(text)
  end

  def _send_mastodon_notification!(text)
    bearer_token = ENV["MASTODON_ACCESS_TOKEN"]
    client = Mastodon::REST::Client.new(base_url: 'https://social.silicon.moe', bearer_token:)

    mastodon_status = client.create_status(text, visibility: 'unlisted', language: 'ko')
    mastodon_status_id = mastodon_status.id

    update!(mastodon_status_id:)
  end
end
