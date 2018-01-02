Rails.application.routes.draw do
  resources :users, only: %i[index show destroy edit new] do
    collection do
      get :import_json
      get :search
    end
  end
  mount PostgresqlLoStreamer::Engine => '/user_picture'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match ':controller(/:action(/:id))', via: %i[get post]
end
