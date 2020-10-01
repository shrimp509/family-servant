Rails.application.routes.draw do
  namespace :webhook do
    post '/', to: 'messaging#hello'
  end

  namespace :habit_tracing do
    get 'new_habit', to: 'habit#new_habit'
    post 'new_habit', to: 'habit#create_habit'

    get 'new_record', to: 'habit#new_record'
    post 'new_record', to: 'habit#create_record'

    get 'success', to: 'habit#success'
  end
end
