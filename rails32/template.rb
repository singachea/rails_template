require 'pry'
$root_directory =  File.expand_path("../", __FILE__)

require "#{$root_directory}/all_dependencies"


gem_group :development do
  gem 'pry'
  gem 'pry-debugger'
  gem 'railroady'
  gem "letter_opener"
  gem 'thin'
end


remove_file "public/index.html"


# readme_run
# database_run
sidekiq_run
twitter_bootstrap_run
haml_run
home_controller_run
user_run






