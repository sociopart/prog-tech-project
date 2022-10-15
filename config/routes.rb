Rails.application.routes.draw do
  resources :items
  resources :roles

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',

  }, :path => '',
     :path_names => { 
        :sign_in => "login",
        :sign_out => "logout",
        :sign_up => "register" 
      }

  get '@:user_id', to: 'users#profile', as: 'user'

  devise_scope :user do  
   get '/logout' => 'devise/sessions#destroy'     
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "main#index"

  # Defines the root path route ("/")
  # root "articles#index"
end
