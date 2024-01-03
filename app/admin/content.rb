# app/admin/content.rb
ActiveAdmin.register Content do
  permit_params :title, :body, :image, :published_at

  index do
    selectable_column
    id_column
    column :title
    column :body
    column :published_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :body, as: :text
      f.input :published_at, as: :datepicker
    end
    f.actions
  end
end
