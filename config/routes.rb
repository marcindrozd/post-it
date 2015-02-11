PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  get '/register', to: "users#new"

  resources :posts, except: :destroy do
    member do
      post 'vote'
    end

    resources :comments, only: [:create] do
      member do
        post 'vote'
      end
    end
  end

  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:create, :show, :edit, :update]
end
