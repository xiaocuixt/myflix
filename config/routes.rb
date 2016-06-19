Myflix::Application.routes.draw do
	root "pages#front"
  get "home", to: "videos#index"

	resources :videos, only: [:show] do
    resources :reviews, only: :create
		collection do
			get :search
		end
	end

  resources :category, only: :show

  get "/my_queue", to: "queue_items#index"
  resources :queue_items, only: [:create, :destroy]

	resources :users, only: :create
	get "/register", to: "users#new"

	get "/sign_in", to: "sessions#new", as: :sign_in
	resources :sessions, only: [:create, :destroy]
	delete "/sign_out", to: "sessions#destroy"

  get 'ui(/:action)', controller: 'ui'

  resources :todos, only: [:index, :new, :create] do
  	collection do
  		get :search, to: "todos#seach"
  	end
  	member do
  		post "highlight", to: "todos#highlight"
  	end
  end
end
