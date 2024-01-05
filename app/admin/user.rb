ActiveAdmin.register User do
  permit_params :email, :encrypted_password,
                :reset_password_sent_at, :remember_created_at,
                :created_at, :updated_at, :otp_secret_key,
                :confirmation_token, :confirmed_at, :confirmation_sent_at,
                :unconfirmed_email, :first_name, :last_name, :profile_picture,
                :notification_preferences, :deleted, :password, :role

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :profile_picture
    column :created_at
    column :role
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :role
    end
  end

  filter :email
  filter :first_name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :role, as: :select, collection: ["user","admin"]
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end
end
