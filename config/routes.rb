Skipper::Application.routes.draw do

  # Users
  devise_for :users, :controllers => {registrations: 'registrations'}, :path => '', :path_names => { :sign_in => "hello", :sign_out => "goodbye" }

  resources :users, :path => "u", only: [:show] do
    member do
      get :subscriptions
    end
  end

  get '/c/all', to: 'subs#index', :as => :subs
  post '/c/all', :to => 'subs#create'

  resources :subs, :path => "c", except: [:index] do
  	get :new, to: 'posts#new'
  	get :selfie, to: 'posts#selfie'
  	post :create_url, to: 'posts#create_url'
  	post :create_selfie, to: 'posts#create_selfie'

  	resources :posts, except: [:new, :selfie, :create_url, :create_selfie]

    member do
      get :subscribers
    end
  end

  resources :subscriptions, only: [:create, :destroy]
  resources :posts do
    member do
      get :up, :down
    end
  end

  match 'remote_sign_up', to: 'remote_content#remote_sign_up', via: [:get]

  root "subs#index"
end
