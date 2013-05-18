LeftOrRight::Application.routes.draw do
  resources :categories, only: [:new, :create, :show, :index, :destroy] do
    resources :elements do
      get 'vote', on: :member
    end
  end

  root :to => 'categories#index'
end
