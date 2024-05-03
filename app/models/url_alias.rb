require "securerandom"

class UrlAlias < ApplicationRecord
  def self.generate_hash
    SecureRandom.alphanumeric(6)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[short long resource]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[]
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
