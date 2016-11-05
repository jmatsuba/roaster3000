Rails.application.routes.draw do
  root 'welcome#index'
  get "roast/", to: "roast#show"
end
