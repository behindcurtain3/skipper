Skipper::Application.routes.draw do
  # Users
  devise_for :users, :controllers => {registrations: 'registrations'}, :path => '', :path_names => { :sign_in => "hello", :sign_out => "goodbye" }

  match 'remote_sign_up', to: 'remote_content#remote_sign_up', via: [:get]

  root "welcome#index"
end
