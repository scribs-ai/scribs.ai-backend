# app/admin/system_configuration.rb
ActiveAdmin.register SystemConfiguration do
  permit_params :key, :value, :description

  index do
    selectable_column
    id_column
    column :key
    column :value
    column :description
    actions
  end

  form do |f|
    f.inputs do
      f.input :key
      f.input :value
      f.input :description
    end
    f.actions
  end
end
