Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :launches, only: [:index, :show] do
        collection do
          get :upcoming
          get :latest
        end
      end

      resources :rockets, only: [:index, :show] do
        resources :launches, only: [:index], controller: "rocket_launches"
      end

      namespace :stats do
        get :launches_per_year
        get :success_rate
        get :streak
        get :providers
      end
    end
  end
end