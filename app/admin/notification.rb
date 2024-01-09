# app/admin/notification.rb
ActiveAdmin.register Notification do
  permit_params :title, :content, :sent_at

  index do
    selectable_column
    id_column
    column :title
    column :content
    column 'Actions' do |notification|
      links = link_to('Send to Site', send_site_admin_notification_path(notification), method: :post)
      links += ' | ' # Add a space between links
      links += link_to('Send Email to All', send_email_all_admin_notification_path(notification), method: :post)
      links += ' | ' # Add a space between links
      links += link_to('View', resource_path(notification), class: 'member_link view_link')
      links += ' | ' # Add a space between links
      links += link_to('Edit', edit_resource_path(notification), class: 'member_link edit_link')
      links += ' | ' # Add a space between links
      links += link_to('Delete', resource_path(notification), method: :delete, data: { confirm: 'Are you sure?' }, class: 'member_link delete_link')
      links.html_safe
    end
  end
  
  show do
    attributes_table do
      row :id
      row :title
      row :content
      row :sent_at
    end
  end

  member_action :send_email_all, method: :post do
    @notification = Notification.find(params[:id])
    send_email_to_group(@notification, User.all)
    redirect_to admin_notifications_path, notice: 'Emails sent successfully to all users.'
  end

  member_action :send_email_selected, method: :get do
    notification = Notification.find(params[:id])
    @users = User.all
  end

  member_action :send_site, method: :post do
    notification = Notification.find(params[:id])
    ActionCable.server.broadcast("notification_channel", notification)
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :content
      f.input :sent_at
    end
    f.actions
  end

  controller do
    def send_email_to_group(notification, users)
      users.each do |user|
        UserMailer.email_notification(user, notification).deliver_now
      end
    end
  end
end
