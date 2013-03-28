require 'pry'
$root_directory =  File.expand_path("../", __FILE__)

require "#{$root_directory}/all_dependencies"


gem "will_paginate", "~> 3.0.3"
gem 'cancan'
gem 'simple_form'
gem 'rabl'
gem 'urbanairship'
gem 'rest-client'

gem_group :development do
  gem 'pry'
  gem 'pry-debugger'
  gem 'railroady'
  gem "letter_opener"
  gem 'thin'
  gem 'pry-remote'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request', '0.2.1'
end


remove_file "public/index.html"


readme_run
database_run
sidekiq_run
twitter_bootstrap_run
haml_run
home_controller_run
user_run






