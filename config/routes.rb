Rails.application.routes.draw do
  root 'static_pages#top'
  get 'signup', to: 'users#new'
  get 'basic_info_update', to: 'static_pages#update'
  
  # ログイン機能
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    collection do
      get 'attendancing_index'
      post 'import'
    end
    resources :attendances, only: :update
  end
end
