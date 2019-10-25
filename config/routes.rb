Rails.application.routes.draw do

  root 'static_pages#home'
  get '/signup',   to: 'users#new'
  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # 基本情報更新 未使用
  # get '/edit_basic_info/:id', to: 'users#edit_basic_info', as: :basic_info
  # patch 'update_basic_info', to: 'users#update_basic_info'
  # 勤怠編集更新
  get 'users/:id/attendances/:date/edit', to: 'attendances#edit', as: :edit_attendances
  patch 'users/:id/attendances/:date/update', to: 'attendances#update', as: :update_attendances
  # 残業申請更新
  get 'users/:id/attendances/:date/edit_overtime', to: 'attendances#edit_overtime', as: :edit_attendances_overtime
  patch 'users/:id/attendances/:date/update_overtime', to: 'attendances#update_overtime', as: :update_attendances_overtime
  # 出勤中社員
  get '/workers', to: 'attendances#index'
  # 拠点情報
  resources :bases
  # 各種お知らせ
  get 'edit_superior_notice', to: 'attendances#edit_superior_notice'
  patch 'update_superior_notice', to: 'attendances#update_superior_notice'
  get 'edit_attendance_notice', to: 'attendances#edit_attendance_notice'
  patch 'update_attendance_notice', to: 'attendances#update_attendance_notice'
  get 'edit_overtime_notice', to: 'attendances#edit_overtime_notice'
  patch 'update_overtime_notice', to: 'attendances#update_overtime_notice'
  
  resources :users do
    collection { post :import }
    resources :attendances, only: :create
  end
end
