class PagesController < ApplicationController
  def show
    render template: "page#show"
  end
end
