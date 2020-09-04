# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :products do
      resources :parts do
        member do
          post :select
          post :remove
          post :set_count
        end
        collection do
          post :available
          get  :selected
          post :update_positions
        end
      end
    end
  end
end
