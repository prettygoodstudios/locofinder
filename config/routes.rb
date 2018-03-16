Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "location#index"
  resources "location"
  resources "review"
  resources "photo"
  resources "report"
  get "/landing", to: "user#landing"
  get "/users/all", to: "user#index"
  get "/collection_api", to: "user#collection_api"
  get "/geo_json_api", to: "location#geo_json_api"
  get "/my_location_api", to: "location#my_location_api"
  get "/user/show/:id", to: "user#show"
  get "/user/enable_account/:id", to: "user#enable_account"
  get "/user/disabled_account/:id", to: "user#disabled_account"
  get "/user/send_email_verification/:id", to: "user#send_email_verification"
  get "/reset_password/:id", to: "user#new_password"
  post "/new_password/:id", to: "user#reset_password"
  delete "/report_destroy/:id", to: "report#report_destroy"
  get "/user/edit_profile/:id", to: "user#edit_profile_image"
  post "/user/update_profile", to: "user#update_profile_image"
end
