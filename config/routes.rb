Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'signup-success' => 'home#signup_success'
end
