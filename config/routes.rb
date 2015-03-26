Rails.application.routes.draw do
  get '/', to: redirect('/racer/Bunny%20GT9')

  get '/racer/:id' => 'racer#show'
end
