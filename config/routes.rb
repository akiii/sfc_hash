SfcHash::Application.routes.draw do
  get "login/submit"
  resources :login
  resources :home, :only => [:index, :add, :edit, :logout] do
  end
  resources :hashtags, :only => [:index, :edit]
  resources :hashtags_candidate, :only => [:index]
  resources :search, :only => [:index]
  resources :works, :only => [:index]

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'login#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  match 'login/submit' => 'login#submit'
  match 'home/add/:subject_info_id' => 'home#add'
  match 'home/edit/:subject_info_id' => 'home#edit'
  match 'home/submit/:state' => 'home#submit'
  match 'home/logout' => 'home#logout'
  match 'search/submit' => 'search#submit'
  match 'tweets/get_tweets_of_hashtags' => 'tweets#get_tweets_of_hashtags'
  match 'tweets/croll_sfc_lists_timeline' => 'tweets#croll_sfc_lists_timeline'
  match 'hashtags/edit/:subject_info' => 'hashtags#edit'
end
