

def haml_run
  gem 'haml-rails'
  environment read_file_and_gsub(__FILE__, "_application.rb")

  remove_file "app/views/layouts/application.html.erb"
  copy_file "#{$root_directory}/templates/haml/application.html.haml", "app/views/layouts/application.html.haml"
  copy_file "#{$root_directory}/templates/haml/_flash.html.haml", "app/views/layouts/_flash.html.haml"
  copy_file "#{$root_directory}/templates/haml/_menu.html.haml", "app/views/layouts/_menu.html.haml"
end