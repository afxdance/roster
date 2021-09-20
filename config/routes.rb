Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html

  # These codes determine the url.
  # get: the url that displays the form
  # post or put: the url that the form's "submit" button leads to.

  # audition_controller
  get "/audition", to: "audition#index"
  post "/audition", to: "audition#create"

  get "/teamswitch", to: "team_switch_form#index"
  post "/teamswitch", to: "team_switch_form#create_team_switch_request", as: "team_switch_form"

  get "/src", to: "src#index"
  post "/src", to: "src#submit"
  get "/src/confirm", to: "src#confirm"
  get "/dancer/:email", to: "dancer#find_team",
                        constraints: { email: %r{[^\/]+} }
  post "/dancer_src", to: "dancer#check_dancer_and_src"

  get "/answer", to: "answer#index"
  post "/answer/new", to: "answer#new"
  post "/answer/remove", to: "answer#remove"
  post "/answer", to: "answer#save"
end
