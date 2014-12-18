Rails.application.routes.draw do

root 'wines#index'

resources :wines

get 'reds', to: 'wines#reds'
get 'whites', to: 'wines#whites'
get 'roses', to: 'wines#roses'
get 'snooth', to: 'wines#snooth'
get 'score', to: 'wines#score'
get 'value', to: 'wines#value'
get 'slot', to: 'wines#slot'
post 'filter', to: 'wines#filter'


end
