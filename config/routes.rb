Rails.application.routes.draw do
  root 'posts#index'

  get 'admin', to: 'posts#edit', as: 'show_news'
  put 'admin', to: 'posts#update', as: 'post_news'
end
