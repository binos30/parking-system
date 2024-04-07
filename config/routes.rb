# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  namespace :api do
    namespace :v1 do
      resources :dashboard, only: :index, defaults: { format: :json }
      resources :entrances, except: %i[new edit], defaults: { format: :json }
      resources :parking_lots, except: %i[new edit], defaults: { format: :json }
      resources :parking_slots, only: :index, defaults: { format: :json }
      resources :bookings, except: %i[new edit], defaults: { format: :json } do
        put :park_vehicle
        put :unpark_vehicle
      end
    end
  end

  get "/*path" => "home#index"
end
