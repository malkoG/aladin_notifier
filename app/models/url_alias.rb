require "securerandom"

class UrlAlias < ApplicationRecord
  include ActionView::Helpers::UrlHelper

  def self.generate_hash
    SecureRandom.alphanumeric(6)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[short long resource]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[]
  end

  def humanized_link
    case resource 
    when 'AladinBookEntry'
      book_entry = AladinBookEntry.find_by(link: long)
      link_to (book_entry&.link || '') do
        "#{book_entry&.title} / #{book_entry&.author}"
      end
    else
      content_tag :div do
      end
    end
  end

  def self.shorten_url(url, resource: '')
    short = ''

    while true
      short = generate_hash
      instance = find_by(short:)

      break instance.nil?
    end

    create!(short:, long: url, resource:)
  end
end
