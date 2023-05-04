Rails.application.routes.draw do
  get 'messages/index'
  get 'messages/:id', to: 'messages#show', as: 'message'
  post '/messages/search' => 'messages#search', as: 'message_search'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'messages#index'
end
