Rails.application.routes.draw do
  resources :archives
  devise_for :users
  root to: 'visitors#index'

  resources :articles
  resources :legislations
  resources :users

  get 'archives/:id/make_articles' => "archives#make_articles", as: :make_articles
end
