# config/routes.rb

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "photos#index"

  devise_for :users

  resources :comments
  resources :follow_requests
  resources :likes
  resources :photos

  get ":username/liked" => "users#liked", as: :liked
  get ":username/feed" => "users#feed", as: :user_feed
  get ":username/followers" => "users#followers", as: :user_followers
  get ":username/following" => "users#following", as: :user_following

  get "/:username" => "users#show", as: :user

end
