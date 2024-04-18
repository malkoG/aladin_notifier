require 'aladin_client'

class AladinNotificationBatchJob < ApplicationJob
  def perform(*)
    client = AladinClient.new
    item_list = client.item_list

    aladin_book_entries = item_list.map { AladinBookEntry.import(_1) }

    aladin_book_entries
      .select(&:present?)
      .select { _1.mastodon_status_id.empty? }
      .reject(&:censorable?)
      .each(&:send_notification!)
  end
end
