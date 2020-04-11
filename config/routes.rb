Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'products#index'

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]
  resources :orders, except: [:new, :edit, :update, :destroy ] do 
    get 'confirm', on: :collection
    
    member do
      delete 'cancel'
      post 'pay'
      get 'pay_confirm'
    end
  end

  resource :cart, only: [:show, :destroy] do
    get :checkout
  end

  namespace :admin do
    root 'products#index'
    resources :products, except: [:show]
    resources :vendors, except: [:show]
    resources :categories, except: [:show] do
      put 'sort', on: :collection
    end
  end

  # POST /api/v1/subscribe
  namespace :api do
    namespace :v1 do
      post 'subscribe', to: 'utils#subscribe'
      post 'cart', to: 'utils#cart'
    end
  end
end
