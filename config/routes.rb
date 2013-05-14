LeftOrRight::Application.routes.draw do
  resources :categories, only: [:new, :create, :show, :index] do
    resources :elements, only: [:new, :create, :show, :index] do
      get 'vote', on: :member
    end
  end

  root :to => 'categories#index'
end
