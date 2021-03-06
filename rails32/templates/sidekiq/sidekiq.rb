

def sidekiq_run
  if yes_or_blank? "Do you want to include sidekiq module?"
    gem 'sidekiq'
    gem 'sinatra', :require => false
    gem 'slim'
    gem 'sidekiq-failures'

    options = {}
    options[:http_username] = ask_with_default("Enter your http username [admin]: ", "admin")
    options[:http_password] = ask_with_default("Enter your http password [admin]: ", "admin")
    options[:mount_path] = ask_with_default("Enter mounting path [sidekiq]: ", "sidekiq")
    route read_file_and_gsub(__FILE__, "_routing.rb", options)
    prepend_to_file 'config/routes.rb', "require 'sidekiq/web'\n\n"

    if yes_or_blank? "Do you want to include Procfile (to run sidekiq with foreman)?"
      gem 'foreman'
      create_file "Procfile", read_file_and_gsub(__FILE__, "_procfile", {app_name: app_name})
      create_file "proc/staging", "RAILS_ENV=staging"
      create_file "proc/production", "RAILS_ENV=production"
    end

    if yes_or_blank? "Do you want to include worker file sample?"
      worker_file_name = ask_with_default("Enter your worker file name [sample]:", "sample").downcase.gsub(/\s+/, "_") + "_worker"
      create_file "app/workers/#{worker_file_name}.rb", read_file_and_gsub(__FILE__, "_worker_sample.rb", {worker_name: worker_file_name.camelize})
    end

  end
end