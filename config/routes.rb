LeftOrRight::Application.routes.draw do
  resources :categories, only: [:new, :create, :show, :index] do
    resources :elements, only: [:new, :show, :index]
  end

  root :to => 'categories#index'
end
