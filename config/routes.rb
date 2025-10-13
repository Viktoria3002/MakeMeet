Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#page1"

  # Маршруты для страниц
  get "page1", to: "pages#page1"
  get "page2", to: "pages#page2"
  get "page3", to: "pages#page3"
  get "page4", to: "pages#page4"

  # Маршруты для админки
  namespace :admin do
    root to: "admin#index"
    get "users", to: "admin#users"
    get "posts", to: "admin#posts"
    get "comments", to: "admin#comments"
    get "sprints", to: "admin#sprints"
    
    delete "users/:id", to: "admin#delete_user", as: :delete_user
    delete "posts/:id", to: "admin#delete_post", as: :delete_post
    delete "comments/:id", to: "admin#delete_comment", as: :delete_comment
    delete "sprints/:id", to: "admin#delete_sprint", as: :delete_sprint
  end
end
