Rails.application.routes.draw do
  get '/', to: redirect('/racer/Bunny%20GT9')

  get '/racer/:id' => 'racer#show'
  get '/racer/:id1/vs/:id2' => 'racer#versus'
end
