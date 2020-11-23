# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      controller :parking do
        post '/parking' => :enter_parking
        put '/parking/:id/out' => :left_parking
        put '/parking/:id/pay' => :pay_parking
        get '/parking/:plate' => :parking_history
      end
    end
  end
end
