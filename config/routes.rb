Rails.application.routes.draw do
  resources :teams, only: [:index, :create, :destroy] do
    member do
      post 'join'
      delete 'leave'
    end
  end
  devise_for :users
  root to: "pages#home"
  
  get 'map', to: 'maps#show'
  get 'team', to: 'pages#team'
  get 'map/next_team_marker', to: 'maps#next_team_marker'
  get 'map/visited_team_markers', to: 'maps#visited_team_markers'
  post 'markers/:id/validate', to: 'maps#validate', as: 'validate_marker'
  post 'map/raz', to: 'maps#raz'
end
