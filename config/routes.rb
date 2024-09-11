EffectivePostmark::Engine.routes.draw do
  namespace :admin do
    resources :postmark, only: [] do
      post :postmark_reactivate, on: :member
    end

    resources :postmark_reports, only: [] do
      collection do
        get :inactive_recipients
      end
    end
  end
end

Rails.application.routes.draw do
  mount EffectivePostmark::Engine => '/', as: 'effective_postmark'
end
