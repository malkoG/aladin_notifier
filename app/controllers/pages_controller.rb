class PagesController < ApplicationController
  def show
    render template: "pages/#{params[:path]}"
  end
end
