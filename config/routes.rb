Rails.application.routes.draw do
  namespace :api do
    # resources :types
    resources :pokemons, only: [:index, :create, :edit]
    # resources :users
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
