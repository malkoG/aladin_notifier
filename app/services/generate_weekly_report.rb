class GenerateWeeklyReport < ApplicationService 
  include Rails.application.routes.url_helpers

  def initialize(target_type:, resource:, metric_type:)
    @target_type = target_type
    @resource = resource
    @metric_type = metric_type
  end

  def call
    scope = Metric.where(target_type: @target_type, resource: @resource, metric_type: @metric_type)
    collections = scope.group(:target_type, :target_id).sum(:amount)

    result = collections.map do |(target_type, target_id), amount|
      {
        **_resolve(target_type, target_id),
        amount:
      }
    end

    result
      .sort_by { |hash| -hash[:amount] }
      .first(10)
      .each_with_index.map { |hash, i| "#{i + 1}위 / #{hash[:title]} / #{hash[:amount]} 회 조회 / #{hash[:url]}" }
  end

  private

  def _resolve(target_type, target_id)
    case target_type
    when 'UrlAlias'
      url_alias = UrlAlias.find(target_id)
      title = ''
      if url_alias.resource == 'AladinBookEntry'
        book_entry = AladinBookEntry.find_by(link: url_alias.long)
        title = book_entry&.title || ''
      end

      url = shortened_redirection_url(url_alias.short)

      {
        title:,
        url:
      }
    else
      {}
    end
  end
end
