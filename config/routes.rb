Rails.application.routes.draw do
  resources :payments, only: [:index] do
  end
  post "payments/callback", controller: "payments", action: :callback
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
