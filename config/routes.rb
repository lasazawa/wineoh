Rails.application.routes.draw do

root 'welcome#index'

resources :varietals do
  resources :wines
end

end
