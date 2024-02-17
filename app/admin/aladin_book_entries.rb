ActiveAdmin.register AladinBookEntry do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :published_at, :item_id, :isbn, :isbn13, :title, :link, :author, :publisher, :description


  index do 
    column :title
    column :isbn
    column :author
    column :publisher
    column :link
    column :published_at
  end

  member_action :send_notification, method: :put do
    resource.lock!
    redirect_to resource_path, notice: "Locked!"
  end
end
