Rails.application.routes.draw do
  
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}
  namespace :scheduler do
  	resources :users 
  	resources :schedules, :except => [:show] do
  		member do
  			get :'schedule_change_requests'
        get :approve_request
        get :reject_request
  		end
  	end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
