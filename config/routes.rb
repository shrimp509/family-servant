Rails.application.routes.draw do
  namespace :webhook do
    post '/', to: 'messaging#hello'
    post 'hello', to: 'application#hello'
  end
end
