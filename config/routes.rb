Rails.application.routes.draw do
  root 'welcome#index'
  get "roast", to: "roast#show"
  get "raw", to: "roast#fullcontact"
end
