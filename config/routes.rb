Skipper::Application.routes.draw do

  # Users
  devise_for :users, :controllers => {registrations: 'registrations'}, :path => '', :path_names => { :sign_in => "hello", :sign_out => "goodbye" }

  resources :users, :path => "u", only: [:show] do
    
  end

  get '/r/all', to: 'crews#index', :as => :crews
  post '/r/all', :to => 'crews#create'

  resources :crews, :path => "r", except: [:index]

  match 'remote_sign_up', to: 'remote_content#remote_sign_up', via: [:get]

  root "crews#index"
end
