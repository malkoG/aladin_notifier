require 'aladin_client'

class AladinNotificationBatchJob < ApplicationJob
  def perform(*)
    client = AladinClient.new
    item_list = client.item_list

    item_list.map { AladinBookEntry.import(_1) }
  end
end
