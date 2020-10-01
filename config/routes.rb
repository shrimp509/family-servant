Rails.application.routes.draw do
  namespace :webhook do
    post '/', to: 'messaging#hello'
  end

  namespace :habit_tracing do
    get '/', to: 'habit#index'
  end
end
