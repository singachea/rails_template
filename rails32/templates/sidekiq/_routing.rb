Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == "http_username" && password == "http_password"
  end
  mount Sidekiq::Web, at: '/mount_path', :as => :mount_path