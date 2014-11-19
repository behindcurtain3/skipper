Skipper::Application.routes.draw do

  # Users
  devise_for :users, :controllers => {registrations: 'registrations'}, :path => '', :path_names => { :sign_in => "hello", :sign_out => "goodbye" }

  resources :users, :path => "u", only: [:show] do
    member do
      get :subscriptions
    end
  end

  get '/r/all', to: 'subs#index', :as => :subs
  post '/r/all', :to => 'subs#create'

  resources :subs, :path => "r", except: [:index] do
  	get :new, to: 'posts#new'
  	get :selfie, to: 'posts#selfie'
  	post :create_url, to: 'posts#create_url'
  	post :create_selfie, to: 'posts#create_selfie'

  	resources :posts, except: [:new]

    member do
      get :subscribers
    end
  end

  resources :subscriptions, only: [:create, :destroy]

  match 'remote_sign_up', to: 'remote_content#remote_sign_up', via: [:get]

  root "subs#index"
end
