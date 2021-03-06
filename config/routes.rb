ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.profile '/profile', :controller => 'users', :action => 'profile'
  map.acc_playing_details '/acc_playing_details', :controller => 'users', :action => 'acc_playing_details'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.home '/home', :controller => 'users', :action => 'home'
  map.new '/new', :controller => 'users', :action => 'new'
  map.about_us '/about_us', :controller => 'users', :action => 'about_us'
  map.contact_us '/contact_us', :controller => 'users', :action => 'contact_us'
  map.new_acc '/new_acc', :controller => 'users', :action => 'new_acc'
  map.index '/index', :controller => 'users', :action => 'index'
  map.edit_acc '/edit_acc', :controller => 'users', :action => 'edit_acc'
  map.update '/update', :controller => 'users', :action => 'update'
  map.change_password '/change_password', :controller => 'users', :action => 'change_password'
  map.update_password '/update_password', :controller => 'users', :action => 'update_password' 
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
 
  
  map.resources :users

  map.resource :session

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "users", :action => 'home'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
