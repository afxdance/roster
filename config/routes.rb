Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # audition_form_controller
  get '/auditionform', to: 'audition_form#index'
  post '/auditionform', to: 'audition_form#create_dancer', as: "audition_form"
  
end
