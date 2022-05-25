Rails.application.routes.draw do
  root to: 'properties#index'
  post '/properties/:id/kill', as: :kill_property, to: 'properties#kill'
  post '/properties/:id/star', as: :star_property, to: 'properties#star'
  get '/properties/starred', to: 'properties#starred'
  get '/heatmap/:rooms', to: 'properties#heatmap'
  get '/sections/:id', to: 'sections#show', as: :section
  post '/sections/:id/scan_now', to: 'sections#scan_now', as: :scan_section
  post '/sections/:id/disable', to: 'sections#disable', as: :disable_section
  post '/sections/:id/enable', to: 'sections#enable', as: :enable_section
  get '/sections/:id/scan_now', to: 'sections#scan_now'
end
