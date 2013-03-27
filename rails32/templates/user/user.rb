


def user_run
  if yes_or_blank? "Do you want to include user module?"
    gem 'bcrypt-ruby', '~> 3.0.0'

    generate :model, "user", "email:string:index", "first_name:string", "last_name:string", "password_digest:string", "password_recoverable:string", "role:string", "auth_token:string", "locked:boolean", "activated:boolean"
    user_file = Dir["#{destination_root}/db/migrate/*create_users.rb"].first
    copy_file "#{$root_directory}/templates/user/db/user_migrate.rb", user_file, force: true
    copy_file "#{$root_directory}/templates/user/controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
    copy_file "#{$root_directory}/templates/user/views/sessions/new.html.haml", "app/views/sessions/new.html.haml"
    copy_file "#{$root_directory}/templates/user/models/user.rb", "app/models/user.rb", force: true
    copy_file "#{$root_directory}/templates/user/controllers/users_controller.rb", "app/controllers/users_controller.rb", force: true

    directory "#{$root_directory}/templates/user/scaffolds", "app/scaffolds"
    inject_into_class "app/controllers/application_controller.rb", "ApplicationController", "\n  include Injection::Controller::Application\n"
    insert_into_file "app/helpers/application_helper.rb", "\n  include Injection::Helper::Application\n", :after => "ApplicationHelper\n"
    directory "#{$root_directory}/templates/user/views/users", "app/views/users"
    directory "#{$root_directory}/templates/user/views/admin", "app/views/admin"
    directory "#{$root_directory}/templates/user/views/shared", "app/views/shared"
    directory "#{$root_directory}/templates/user/controllers/admin", "app/controllers/admin"

    create_file "app/assets/javascripts/users.js.coffee", ""
    create_file "app/assets/javascripts/admin/users.js.coffee", ""
    create_file "app/assets/stylesheets/users.css.scss", ""
    create_file "app/assets/stylesheets/admin/users.css.scss", ""

    directory "#{$root_directory}/templates/user/workers", "app/workers"


    route read_file_and_gsub(__FILE__, "config/route.rb")
    admin_email = ask_with_default("Enter your admin email [admin@2359media.com]:", "admin@2359media.com")
    admin_password = ask_with_default("Enter your admin password [adminadmin]:", "adminadmin")

    append_to_file "db/seeds.rb", read_file_and_gsub(__FILE__, "db/seeds.rb", {admin_email: admin_email, admin_password: admin_password})

    run_bundle 
    rake "db:create"
    rake "db:migrate"
    rake "db:seed"
  end
end