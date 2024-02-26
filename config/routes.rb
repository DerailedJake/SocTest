Rails.application.routes.draw do
  get 'landing' => 'static_pages#landing', as: 'static_pages_landing'
  get 'static_pages/about'
  get 'static_pages/contact'
  get 'static_pages/legal'

  get 'users/home'
  get 'users/profile/(:id)'=> 'users#profile', as: 'profile'
  get 'users/index'


  resources :posts, only: [:new, :edit, :create, :index]

  resources :stories

  resources :comments, only: [:create, :update, :destroy]

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "users#home"
end
