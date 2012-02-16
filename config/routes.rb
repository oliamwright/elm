Tm::Application.routes.draw do
  devise_for :users

	match 'recent_activity' => 'log_events#index', :as => :recent_activity
	match 'all_recent_activity' => 'log_events#all', :as => :all_recent_activity

	resources :log_events
	resources :questions
	resources :answers

	resources :roles do
		member do
			get 'grant'
			post 'grant_permission'
			post 'revoke_permission'
		end
	end

	resources :companies

	match 'permissions/scope/:scope' => 'permissions#for_scope', :as => :permissions_for_scope
	match 'permissions' => 'permissions#unscoped', :as => :unscoped_permissions

	resources :users do
		member do
			post 'become'
			get 'user_data'
			get 'user_perms'
			get 'global_user_perms'
			get 'assign_role'
			post 'do_assign_role'
			post 'do_remove_role'
			get 'assign_project_role'
			post 'do_assign_project_role'
			post 'do_remove_project_role'
		end
	end

	resources :task_ownerships
	resources :stories do

		member do
			post 'pull'
			post 'push'
		end

		resources :sub_items do
			collection do
				post 'do_action'
			end
		end
	end

	resources :sub_items do
		collection do
			post 'do_action'
		end
	end

	resources :projects do
		resources :users do
			member do
				get 'user_perms'
				get 'global_user_perms'
				get 'assign_role'
				post 'do_assign_role'
				post 'do_remove_role'
				get 'assign_project_role'
				post 'do_assign_project_role'
				post 'do_remove_project_role'
			end
		end

		member do
			get 'team'
			get 'backlog'
      get 'test_output'
		end

		resources :sprints do
			resources :stories do
				member do
					post 'pull'
					post 'push'
				end
			end
		end

		resources :stories do
			member do
				post 'pull'
				post 'push'
			end

			resources :sub_items do
				collection do
					post 'do_action'
				end
			end
		end
	end

#	namespace :user do
#		root :to => "transactions#index"
#	end

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
  # root :to => "welcome#index"
	root :to => "application#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
