Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :assets
  post '/upload_file', to: 'assets#upload_csv_file'
end
