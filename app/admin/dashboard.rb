ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Sidebar' do
          ul do
            li link_to('Workspace Selector', admin_dashboard_path)
            li link_to('Recent', admin_dashboard_path)
            li link_to('AI Editor', admin_dashboard_path)
            li link_to('Knowledge', admin_dashboard_path)
            li link_to('Chat Bot', admin_dashboard_path)
            li link_to('AI Generators', admin_dashboard_path)
            li link_to('Workflows', admin_dashboard_path)
            li link_to('Guide', admin_dashboard_path)
            li link_to('Promotions (For non-subscribed users)', admin_dashboard_path)
            li link_to('Limits', admin_dashboard_path)
            li link_to('Account Settings', admin_dashboard_path)
            li link_to('Settings', admin_dashboard_path)
            li link_to('System Configuration', admin_dashboard_path)
          end
        end
      end

      column do
        panel 'Main Content' do
          # Your content for the main area
          h2 "Welcome to the Dashboard"
          p "This is your custom Active Admin dashboard."
        end
      end
    end
  end
end