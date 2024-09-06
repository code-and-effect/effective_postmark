EffectivePostmark::Engine.routes.draw do
  namespace :admin do
    resources :postmark, only: [:index]
  end
end

Rails.application.routes.draw do
  mount EffectivePostmark::Engine => '/', as: 'effective_postmark'
end
