Rails.application.routes.draw do
  resources :archives
  devise_for :users
  root to: 'articles#index'

  resources :articles
  resources :legislations
  resources :users
  resources :comments

  get 'archives/:id/make_comments' => "archives#make_comments", as: :make_comments
  get 'archives/:id/make_articles' => "archives#make_articles", as: :make_articles

  get 'articles/API/:number/:legislation' => "articles#api_request", as: :retrieve_api_data
  get 'leg/API' => "legislations#api_request", as: :legislation_api_request

  get '/gil' => 'admin#index', as: :admin_path
end
