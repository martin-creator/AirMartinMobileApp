Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      get '/logout' => 'users#logout'
      post '/facebook' => 'users#facebook'
      post '/payments' => 'users#add_card'

      resources :rooms do
      member do
        get '/reservations', to: 'reservations#reservations_by_room'
      end
      end
      resources :reservations do
        member do
          post '/approve', to: 'reservations#approve'
          post '/decline', to: 'reservations#decline'
        end
      end
      
    end
  end
end
