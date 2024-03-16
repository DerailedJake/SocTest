Rails.application.routes.draw do
  get 'landing' => 'static_pages#landing', as: 'static_pages_landing'
  get 'static_pages/about'
  get 'static_pages/contact'
  get 'static_pages/legal'

  get 'users/home'
  get 'users/profile/(:id)' => 'users#profile', as: 'profile'
  get 'users/index'

  get 'stories/display_stories', as: 'display_stories'
  get 'posts/display_posts', as: 'display_posts'

  get 'stories/timeline'

  post 'like' => 'likes#like', as: 'like'
  get 'liked' => 'likes#liked', as: 'liked'
  get 'liked_things' => 'likes#liked_things'

  get 'tags' => 'tags#index'
  post 'search_tags' => 'tags#search'
  post 'add_tag_to_thing' => 'tags#add_tag_to_thing'

  resources :posts

  resources :stories

  resources :comments, only: [:index, :create, :edit, :update, :destroy]

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "users#home"
end
