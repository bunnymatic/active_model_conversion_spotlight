ActiveModelConversion::Application.routes.draw do

  match 'instagram_widget', :to => 'pages#instagram_widget', :via => [:get]

  get '/widgets', :to => 'widgets#index'
  get '/widgets/:action', :controller => 'widgets'

  root 'pages#index'
end
