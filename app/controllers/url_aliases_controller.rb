class UrlAliasesController < ApplicationController
  def show 
    url_alias = UrlAlias.find_by(short: params[:hash])

    redirect_to url_alias.long, allow_other_host: true
  end
end
