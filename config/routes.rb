Rails.application.routes.draw do
  get '/', to: redirect('/races')

  get '/racers/:id' => 'racer#show'
  get '/racers/:id1/vs/:id2' => 'racer#versus'
  get '/races' => 'race#index'
  get '/races/:id' => 'race#show'
  get '/karts' => 'kart#index'
  
end
