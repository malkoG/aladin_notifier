class AddPathForToUrlAliases < ActiveRecord::Migration[7.1]
  def change
    add_column :url_aliases, :resource, :string, default: ''
    add_column :metrics, :resource, :string, default: ''

    reversible do |dir|
      dir.up do 
        UrlAlias.all.each do |url_alias|
          url_alias.update!(resource: 'AladinBookEntry')
        end

        Metric.all.each do |metric| 
          metric.update!(resource: 'AladinBookEntry')
        end
      end
    end
  end
end
