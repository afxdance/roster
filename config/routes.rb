Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
<<<<<<< HEAD
  get '/teamswitchform', to: 'team_switch_form#index'
  post '/teamswitchform', to: 'team_switch_form#create_team_switch_request', as: "team_switch_form"
=======
>>>>>>> origin/team-switch-approval
end
