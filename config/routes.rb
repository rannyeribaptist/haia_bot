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
end
