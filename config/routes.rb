Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "location#index"
  resources "location"
  resources "review"
  resources "photo"
  get "/geo_json_api", to: "location#geo_json_api"
  get "/user/show/:id", to: "user#show"
  get "/user/verify_email/:id", to: "user#verify_email"
  get "/user/disabled_account/:id", to: "user#disabled_account"
end
