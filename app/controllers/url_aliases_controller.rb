class UrlAliasesController < ApplicationController
  def show 
    url_alias = UrlAlias.find_by(short: params[:hash])

    metric = Metric.find_or_create_by(target: url_alias, date: Date.today, metric_type: 'daily_visit')
    metric.increase_amount!

    redirect_to url_alias.long, allow_other_host: true
  end
end
