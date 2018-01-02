Rails.application.routes.draw do
  resources :users
  mount PostgresqlLoStreamer::Engine => '/user_picture'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match ':controller(/:action(/:id))', via: %i[get post]
end
