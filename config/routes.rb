Rails.application.routes.draw do
  devise_for :users

  root "events#index"

  resources :events, only: [:index] do
    collection do
      post :create_event_a
      post :create_event_b
    end   
  end
end
