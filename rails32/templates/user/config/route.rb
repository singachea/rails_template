get "login", to: "sessions#new", as: "login"
  delete "logout", to: "sessions#destroy", as: "logout"
  
  resource :profile, :controller => :users do
    get :forget_password
    post :post_forget_password
    match "retrieve_password/:id/:expired/:digest", :to => "users#retrieve_password", :as => :retrieve_password, :via => :get
    match "activate/:id/:key/:digest", :to => "users#activate", :as => :activate, :via => :get
  end

  resource :sessions, :only => [:new, :create, :destroy]
  namespace :admin do
    resources :users do
      member do
        post :toggle
      end
    end
  end