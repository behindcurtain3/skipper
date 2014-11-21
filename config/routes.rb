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
    resources :posts, only: [:index, :show, :new, :create]
    #member do 
      #get 'comments/:post_id(/:display)', to: 'posts#show', :as => :comments
    #end

    member do
      get :subscribers
    end
  end

  resources :posts, only: [:edit, :update, :destroy, :up, :down] do
    member do
      get :up, :down
    end
  end

  resources :subscriptions, only: [:create, :destroy]
  
  resources :comments, only: [:create] do
    member do
      post :reply
      get :like, :dislike, :children
    end
  end

  match 'remote_sign_up', to: 'remote_content#remote_sign_up', via: [:get]

  root "subs#index"
end
