Rails.application.routes.draw do
  root 'home#landing_page'
  get "/experiments/:id.pdf" => "experiments#pdf"
  get "/experiments/trash" => "experiments#trash", as: :trash
  get "/experiments/download" => "experiments#download", as: :download
  post "/experiments/:id/restore" => "experiments#restore", as: :restore_experiment
  get "/backups" => "backups#index", as: :backups
  get "/backups/:id" => "backups#download", as: :backup
  get "/contact" => "contact#index"
  resources :dangers
  resources :cover_pictures
  devise_for :users, path: ''
  resources :media
  resources :equipment
  resources :experiments
  resources :users
  resources :sub_categories
  resources :categories
  resource :checkout do
    patch :add_experiment
    delete :remove_experiment
  end
  resource :lecturer_week, only: [:new, :show]
end
