Rails.application.routes.draw do

  root 'static_pages#home'
  get '/signup',   to: 'users#new'
  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/edit_basic_info/:id', to: 'users#edit_basic_info', as: :basic_info
  patch 'update_basic_info', to: 'users#update_basic_info'
  get 'users/:id/attendances/:date/edit', to: 'attendances#edit', as: :edit_attendances
  patch 'users/:id/attendances/:date/update', to: 'attendances#update', as: :update_attendances
  
  get 'working_employee/index'
  
  get 'bases_info/index'
  resources :bases_info do
  end
  
  resources :users do
    member do
      get 'edit_overtime_app'
      patch 'update_overtime_app'
    end
    resources :attendances, only: :create
  end
end
