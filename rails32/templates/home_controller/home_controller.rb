
def home_controller_run
  if yes_or_blank? "Do you want to generate dummy home controller?"
    generate :controller, "homes", "index"
    route("root to: 'homes#index'")
  end
end