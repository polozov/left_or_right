LeftOrRight::Application.routes.draw do
  devise_for :users

  resources :categories do
    resources :elements do
      get 'vote', on: :member
    end
  end

  root to: 'categories#index'
end
