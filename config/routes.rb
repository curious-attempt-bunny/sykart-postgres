Rails.application.routes.draw do
  get '/' => 'race#index'

  get '/racers/:id' => 'racer#show'
  get '/racers/:id1/vs/:id2' => 'racer#versus'
  get '/races' => 'race#index'
  get '/races/:id' => 'race#show'
  get '/karts' => 'kart#index'
  get '/karts2' => 'kart#index2'
  get '/hours/races' => 'hour#races'
  get '/hours/qualifiers' => 'hour#qualifiers'

end
