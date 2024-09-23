Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # get 'map', to: 'pages#map'
  get 'map', to: 'maps#show'
  get 'team', to: 'pages#team'
  get 'map/next_team_marker', to: 'maps#next_team_marker' # POST request to get the next team marker
  get 'map/visited_team_markers', to: 'maps#visited_team_markers' # GET request to get the visited team markers

  # get 'next_team_marker', to: 'maps#next_team_marker'
end
