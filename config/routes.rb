Rails.application.routes.draw do
  root 'pages#index'

  get '/question/:id', to: "questions#details"

  namespace :api do
    namespace :v1 do
      post 'questions/create'
    end
  end
end
