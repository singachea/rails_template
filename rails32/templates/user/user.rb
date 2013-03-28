


def user_run
  if yes_or_blank? "Do you want to include user module?"
    gem 'bcrypt-ruby', '~> 3.0.0'
    user_prepare_model
    user_prepare_views_and_controllers
    user_application_support
    directory "#{$root_directory}/templates/user/workers", "app/workers"
    route read_file_and_gsub(__FILE__, "config/route.rb")
    user_prepare_mail
    user_seeding
  end
end

def user_prepare_model
    generate :model, "user", "email:string:index", "first_name:string", "last_name:string", "password_digest:string", "password_recoverable:string", "role:string", "auth_token:string", "locked:boolean", "activated:boolean"
    user_file = Dir["#{destination_root}/db/migrate/*create_users.rb"].first
    copy_file "#{$root_directory}/templates/user/db/user_migrate.rb", user_file, force: true
    copy_file "#{$root_directory}/templates/user/models/user.rb", "app/models/user.rb", force: true
end

def user_prepare_views_and_controllers
    copy_file "#{$root_directory}/templates/user/controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
    copy_file "#{$root_directory}/templates/user/views/sessions/new.html.haml", "app/views/sessions/new.html.haml"

    copy_file "#{$root_directory}/templates/user/controllers/users_controller.rb", "app/controllers/users_controller.rb", force: true    
    directory "#{$root_directory}/templates/user/views/users", "app/views/users"
    directory "#{$root_directory}/templates/user/views/admin", "app/views/admin"
    directory "#{$root_directory}/templates/user/controllers/admin", "app/controllers/admin"

    create_file "app/assets/javascripts/users.js.coffee", ""
    create_file "app/assets/javascripts/admin/users.js.coffee", ""
    create_file "app/assets/stylesheets/users.css.scss", ""
    create_file "app/assets/stylesheets/admin/users.css.scss", ""
    create_file "app/assets/javascripts/sessions.js.coffee", ""
    create_file "app/assets/stylesheets/sessions.css.scss", ""
end

def user_application_support
    directory "#{$root_directory}/templates/user/scaffolds", "app/scaffolds"
    inject_into_class "app/controllers/application_controller.rb", "ApplicationController", "\n  include Injection::Controller::Application\n"
    insert_into_file "app/helpers/application_helper.rb", "\n  include Injection::Helper::Application\n", :after => "ApplicationHelper\n"    
    directory "#{$root_directory}/templates/user/views/shared", "app/views/shared"
    directory "#{$root_directory}/templates/user/app_utilities", "app/utilities"
end

def user_prepare_mail
    default_sender_email = ask_with_default("Enter your default sender email [admin@2359media.com]:", "admin@2359media.com") 
    create_file "app/mailers/mail_user.rb", read_file_and_gsub(__FILE__, "mailers/mail_user.rb", {default_sender_email: default_sender_email})
    directory "#{$root_directory}/templates/user/views/mail_user", "app/views/mail_user"

    config_settings = <<CONFIG

    config.action_mailer.default_url_options = { :host => "localhost:3000" }
    config.action_mailer.delivery_method = :letter_opener
CONFIG

    insert_into_file "config/environments/development.rb", config_settings, :after => "Application.configure do\n"
end

def user_seeding
    admin_email = ask_with_default("Enter your admin email [admin@2359media.com]:", "admin@2359media.com")
    admin_password = ask_with_default("Enter your admin password [adminadmin]:", "adminadmin")
    append_to_file "db/seeds.rb", read_file_and_gsub(__FILE__, "db/seeds.rb", {admin_email: admin_email, admin_password: admin_password})
    run_bundle
    rake "db:drop" 
    rake "db:create"
    rake "db:migrate"
    rake "db:seed"    
end


