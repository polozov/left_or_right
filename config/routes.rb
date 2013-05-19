LeftOrRight::Application.routes.draw do
  resources :categories do
    resources :elements do
      get 'vote', on: :member
    end
  end

  root to: 'categories#index'
end
