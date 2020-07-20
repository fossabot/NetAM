require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    confirmation: 'verification',
    unlock: 'unblock',
    registration: 'register',
    sign_up: 'cmon_let_me_in'
  }, controllers: { omniauth_callbacks: "callbacks" }

  post 'install', as: 'install', to: 'application#install', format: false

  resources :sections, format: false do
    post 'scan', as: 'scan', to: 'sections#scan', format: false
    post 'export', as: 'export', to: 'sections#export', format: false

    resources :usages, format: false do
      post 'scan', as: 'scan', to: 'usages#scan', format: false
    end
  end

  resources :permissions, except: [:show]
  resources :api_keys, only: %i[index create destroy]

  mount API::Base, at: '/'

  authenticate :user, ->(u) { u.admin? } do
    namespace :admin do
      resources :users
    end

    mount GrapeSwaggerRails::Engine => '/docs'
    mount Sidekiq::Web => '/sidekiq'
  end
end
