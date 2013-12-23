ActiveModelConversion::Application.routes.draw do
  match 'instagram_widget', :to => 'pages#instagram_widget', :via => [:get]
  root 'pages#index'
end
