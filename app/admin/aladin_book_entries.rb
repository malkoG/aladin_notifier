ActiveAdmin.register AladinBookEntry do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :published_at, :item_id, :isbn, :isbn13, :title, :link, :author, :publisher, :description, :mastodon_status_id


  index do 
    selectable_column

    column :title
    column :isbn
    column :author
    column :publisher
    column :link
    column :published_at
    column :mastodon_status_id
    column :price
    
    actions defaults: true, dropdown: true do |resource|
      item "Send to mastodon", send_notification_admin_aladin_book_entry_path(resource), method: :put
    end
  end
  

  form do |f|
    f.inputs "Basic Information" do 
      f.input :title
      f.input :description
    end

    f.inputs "External" do
      f.input :mastodon_status_id 
    end

    f.actions
  end
  member_action :send_notification, method: :put do
    resource.send_notification!
    redirect_to admin_aladin_book_entries_url, notice: "Sent to mastodon!"
  end
end
