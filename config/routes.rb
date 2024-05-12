Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/books/:id" => "books#show"
  delete "/books/:id" => "books#destroy"
  resources :publishers
  # resourceは、indexアクションを除き、:idによる絞り込みも行わない
  resource :profile
  # resource :profile, only: %i{show, edit, update}

  # resourcesは、全てのアクションを自動生成する
  # resources :publishers do
  #   resources :books
  #   # memberはidを指定してアクセスする
  #   member do
  #     get "detail"
  #   end
  #   # collectionはidを指定せずにアクセスする
  #   collection do
  #     get "search"
  #   end
  # end
end
