require 'sidekiq/web'
Rails.application.routes.draw do
  resources :comments
  mount Sidekiq::Web => '/sidekiq'
  get 'search', to: 'search#index'
  resources :posts do
    member do
      post :edit
    end
    collection do
      post 'clearance'
    end
    resources :comments 
  end

  post 'like/:id', to: 'posts#like', as: 'like_post'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',

  }, :path => '',
     :path_names => { 
        :sign_in => "login",
        :sign_out => "logout",
        :sign_up => "register" 
      }

  get '@:user_tag', to: 'users#profile', as: 'user'
  get 'posts' => 'posts#index', :as => 'user_root'
  get 'talantes', to: 'users#talantes'
  devise_scope :user do  
   get '/logout' => 'devise/sessions#destroy'     
  end
  
  post 'profile/follow', to: 'users#follow'
  delete 'profile/unfollow', to: 'users#unfollow'  

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "main#index"

  # Defines the root path route ("/")
  # root "articles#index"
end
