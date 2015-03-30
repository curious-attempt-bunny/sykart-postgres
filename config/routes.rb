Rails.application.routes.draw do
  get '/', to: redirect('/races')

  get '/racer/:id' => 'racer#show'
  get '/racer/:id1/vs/:id2' => 'racer#versus'
  get '/races' => 'race#index'
  
end
