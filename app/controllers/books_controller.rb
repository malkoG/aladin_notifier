class BooksController < ApplicationController
  def index
    @books = AladinBookEntry.all
  end
end
