Rails.application.routes.draw do

root 'wines#index'

resources :wines

get 'snooth', to: 'wines#snooth'
get 'score', to: 'wines#score'
get 'value', to: 'wines#value'
get 'slot', to: 'wines#slot'


end
