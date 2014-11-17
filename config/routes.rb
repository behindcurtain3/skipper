Skipper::Application.routes.draw do
  devise_for :users

  devise_scope :user do
    get "signin", to: "devise/sessions#new"
    get "newb", to: "devise/registrations#new"
  end

  root "welcome#index"
end
