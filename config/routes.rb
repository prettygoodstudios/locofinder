Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "location#index"
  resources "location"
  resources "review"
  resources "photo"
  resources "report"
  get "admin", to: "admin#index"
  get "/googleb644d22d0a6d8ad2.html", to: "report#googleb644d22d0a6d8ad2"
  get "/landing", to: "user#landing"
  get "/users/all", to: "user#index"
  get "/collection_api", to: "photo#collection_api"
  get "/geo_json_api", to: "location#geo_json_api"
  get "/my_location_api", to: "location#my_location_api"
  get "/user/show/:id", to: "user#show"
  get "/user/enable_account/:id", to: "user#enable_account"
  get "/user/disabled_account/:id", to: "user#disabled_account"
  get "/user/send_email_verification/:id", to: "user#send_email_verification"
  post "/reset_password", to: "user#reset_password"
  get "/new_password/:id", to: "user#new_password"
  post "/change_password/:id", to: "user#change_password"
  delete "/report_destroy/:id", to: "report#report_destroy"
  get "/user/edit_profile/:id", to: "user#edit_profile_image"
  post "/user/update_profile", to: "user#update_profile_image"
  namespace :api do
    namespace :v1 do
      resources :sessions
      resources :locations
      resources :photos
      resources :users
      resources :reviews
      resources :reports

      post "/sessions/authenticate", to: "sessions#authenticate"
      post "/sessions/create_user", to: "sessions#create_user"
      post "/sessions/edit_user", to: "sessions#edit_user"
      post "/users/password/reset", to: "users#reset_password"

      get "/locations/find/search", to: "locations#search"

    end
  end
end
