require 'aladin_client'

class AladinBookEntry
  attr_accessor :book_information

  def initialize(book_information)
    @book_information = book_information
  end
end
