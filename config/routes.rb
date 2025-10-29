Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#about"

  # Маршруты для страниц
  get "about", to: "pages#about", as: :about
  get "register", to: "pages#register", as: :register
  get "login", to: "pages#login", as: :login
  get "page1", to: "pages#page1", as: :page1
  get "page2", to: "pages#page2", as: :page2
  get "page3", to: "pages#page3", as: :page3
  get "page4", to: "pages#page4", as: :page4

  # Маршруты для админки
  namespace :admin do
    get "login", to: "admin#login", as: :login
    post "login", to: "admin#login"
    root to: "admin#index"
    get "users", to: "admin#users"
    get "posts", to: "admin#posts"
    get "comments", to: "admin#comments"
    get "sprints", to: "admin#sprints"
    
    get "users/:id/edit", to: "admin#edit_user", as: :edit_user
    get "posts/:id/edit", to: "admin#edit_post", as: :edit_post
    get "comments/:id/edit", to: "admin#edit_comment", as: :edit_comment
    get "sprints/:id/edit", to: "admin#edit_sprint", as: :edit_sprint
    
    patch "users/:id", to: "admin#update_user", as: :update_user
    patch "posts/:id", to: "admin#update_post", as: :update_post
    patch "comments/:id", to: "admin#update_comment", as: :update_comment
    patch "sprints/:id", to: "admin#update_sprint", as: :update_sprint
    
    delete "users/:id", to: "admin#delete_user", as: :delete_user
    delete "posts/:id", to: "admin#delete_post", as: :delete_post
    delete "comments/:id", to: "admin#delete_comment", as: :delete_comment
    delete "sprints/:id", to: "admin#delete_sprint", as: :delete_sprint
  end
end
