require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get 'search', to: 'search#index'
  resources :posts do
    member do
      post :edit
    end
    resources :comments do
      member do
        post :edit
      end
    end
  end

  post 'like/:id', to: 'posts#like', as: 'like_post'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
    
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

  resources :rooms, only: [:show, :destroy]
  get '/messages', to: 'rooms#index', as: 'rooms'

  resources :messages, only: %i[create show update]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "main#index"

end
