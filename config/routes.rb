ActiveModelConversion::Application.routes.draw do
  resources :things

  resources :stuffs

  root 'pages#index'
end
