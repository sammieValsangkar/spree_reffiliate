Spree::Core::Engine.routes.draw do
  get 'r/:code' => 'reffiliate#referral', as: 'referral'
  get 'a/:path' => 'reffiliate#affiliate', as: 'affiliate'
  get 'a/:path/:p' => 'reffiliate#affiliate', as: 'affiliate_product'

  namespace :admin do
    resources :affiliates
  end
end
