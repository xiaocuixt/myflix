  Myflix::Application.routes.draw do
	root "pages#front"
  get "home", to: "videos#index"

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

	resources :videos, only: [:show] do
    resources :reviews, only: :create
		collection do
			get :search
      get :advanced_search, to: "videos#advanced_search", as: :advanced_search
		end
	end
  get '/people', to: "relationships#index", as: :people
  resources :relationships, only: [:destroy, :create]

  resources :category, only: :show

  get "/my_queue", to: "queue_items#index"
  resources :queue_items, only: [:create, :destroy]
  post :update_queue, to: "queue_items#update_queue"

	resources :users, only: [:create, :show]
	get "/register", to: "users#new"
  get "/register/:token", to: "users#new_with_invitation_token", as: :register_with_token

	get "/sign_in", to: "sessions#new", as: :sign_in
	resources :sessions, only: [:create, :destroy]
	delete "/sign_out", to: "sessions#destroy"

  get "forgot_password", to: "forgot_passwords#new"
  resources :forgot_passwords, only: :create
  get "forgot_password_confirmation", to: "forgot_passwords#confirm"
  get "expired_token", to: "forgot_passwords#expired_to"

  resources :password_resets, only: [:create, :show]

  resources :invitations, only: [:new, :create]

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
