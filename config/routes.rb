Rails.application.routes.draw do

  resources :data_queries
  post 'data_queries/save'

  devise_for :admins, :skip => [:registrations]
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root 'pages#main'

  resources :documents
  resources :logs, only: [:index]

  get 'analytics/index'
  post 'analytics/all'
  get 'analytics/filter'
  get 'analytics/group'
  get 'analytics/transformation'
  get 'analytics/measures'
  get 'analytics/synthetic_data'

  get 'pages/main'
  get 'pages/about'
  get 'pages/explore'
  post 'pages/get_explore_data'

  get 'data_interactive/index'

  # Temporary Login Solution for CODAP hosted simultaneously with Rails (in Public folder)
  post '/DataGames/api/auth/login', to: 'auth#index'

  # devise_scope :user do
  #   post "/api/auth/login", to: "devise/sessions#new"
  # end

  # Used for receiving form data from DataInteractive UI and apply appropriate transformation
  post 'group_transform', to: 'group_transform#index'
  post 'table_transform', to: 'table_transform#index'

  namespace :api, defaults: {format: 'json'} do

    # To allow CORS request. The browser first sends an Options request which is matched to logs#options
    match 'logs', to: 'logs#render204', via: [:options]
    match 'is', to: 'logs#render204', via: [:options]

    # API to receive log(s) and store it in database
    post 'logs', to: 'logs#create'

    # To import some IS data in log manager
    post 'is', to: 'is#index'

    # CODAP API component
    post 'auth/login'
    get 'document/all'
    get 'document/open'
    post 'document/save'

  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
