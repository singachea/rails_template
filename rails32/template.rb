#require 'pry'
$root_dir =  File.expand_path("../", __FILE__)
$templates_dir =  File.expand_path("../templates", __FILE__)
require "#{$root_dir}/all_dependencies"


remove_file "public/index.html"


#readme_run
#database_run
sidekiq_run

