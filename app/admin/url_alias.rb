ActiveAdmin.register UrlAlias do 
  index do 
    column :short 
    column :long 
    column :humanized_link do |url_alias|
      url_alias.humanized_link
    end
    column :resource
  end
end
