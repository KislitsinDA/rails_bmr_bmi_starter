Rails.application.routes.draw do
  resources :patients do
    member do
      post :bmr_calculate
      get  :bmr_history
      get  :bmi
    end
  end
  resources :doctors
end
