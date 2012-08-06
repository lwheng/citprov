Citprov::Application.routes.draw do
  
  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'pages#home', :as => "home"
  match '/home' => 'pages#home', :as => "home"
  match '/citation' => 'pages#citation', :as => "citation"
  match '/about' => 'pages#about', :as => "about"
  match '/contact' => 'pages#contact', :as => "contact"
  match '/type' => 'pages#type', :as => "type"
  match '/download' => 'pages#download', :as => "download"
  match '/upload' => 'annotations#upload', :as => "upload"
  match '/upload_data' => 'annotations#upload_data', :as => "upload_data"
  match '/annotate/start' => 'sessions#new', :as => "annotate_start"
  match '/annotate/create' => 'sessions#create', :as => "annotate_create"
  match '/annotate/end' => 'sessions#destroy', :as => "annotate_end"
  match '/annotate/work' => 'pages#annotate', :as => "annotate_work"
  match '/annotate/display' => 'pages#display', :as => "annotate_display"
  match '/annotate/submit' => 'pages#annotate_submit', :as => "annotate_submit"
  match '/admin' => 'pages#admin', :as => "admin"
  match '/admin_submit' => 'pages#admin_submit', :as => "admin_submit"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with 'root'
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with 'rake routes'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
