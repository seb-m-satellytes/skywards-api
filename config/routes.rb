Rails.application.routes.draw do
  scope '/api/v1' do
    resources :activities do
      member do
        post 'evaluate', to: 'activities#evaluate'
      end
    end
    
    
    resources :resources
    resources :characters do
      member do
        post 'start_activity', to: 'characters#start_activity'
     end
    end
    
    resources :settlements
    resources :buildings
    
    resources :game_sessions
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
