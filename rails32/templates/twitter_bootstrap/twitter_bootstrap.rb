
def twitter_bootstrap_run
  
  gem_group :assets do
    gem 'bootstrap-sass'
    gem 'bootstrap-google-sass'
  end

  copy_file "#{$root_directory}/templates/twitter_bootstrap/application.js", "app/assets/javascripts/application.js", force: true
  copy_file "#{$root_directory}/templates/twitter_bootstrap/application.css", "app/assets/stylesheets/application.css", force: true
  copy_file "#{$root_directory}/templates/twitter_bootstrap/lib_pagination.css.scss", "app/assets/stylesheets/lib_pagination.css.scss"
  copy_file "#{$root_directory}/templates/twitter_bootstrap/shared.css.scss", "app/assets/stylesheets/shared.css.scss"

end