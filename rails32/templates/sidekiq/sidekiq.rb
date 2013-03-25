

def sidekiq_run
  if ask_yes_no "Do you want to include sidekiq module?"
    gem 'sidekiq'
    gem 'sinatra', :require => false
    gem 'slim'
    gem 'sidekiq-failures'

    options = {}
    options[:http_username] = ask_with_default("Enter your http username [admin]: ", "admin")
    options[:http_password] = ask_with_default("Enter your http password [admin]: ", "admin")
    options[:mount_path] = ask_with_default("Enter mounting path [sidekiq]: ", "sidekiq")
    route read_file_and_gusb(__FILE__, "_routing.rb", options)
    prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n\n"

    if ask_yes_no "Do you want to include Procfile (to run sidekiq with foreman)?"
      gem 'foreman'
      create_file "Procfile", read_file_and_gusb(__FILE__, "_procfile", {app_name: app_name})
      create_file "proc/staging", "RAILS_ENV=staging"
      create_file "proc/production", "RAILS_ENV=production"
    end

  end
end