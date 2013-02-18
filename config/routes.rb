Matos::Application.routes.draw do

  ActiveAdmin.routes(self)

  root :to => 'home#index'
  match '/about' => 'home#about', :as => :about, :via => :get
  match '/acoustic_telemetry' => 'home#acoustic_telemetry', :as => :acoustic_telemetry, :via => :get
  match '/have_data' => 'home#have_data', :as => :have_data, :via => :get

  devise_for :users

  resources :users, :only => [:index, :destroy, :update]
  match 'users/newsletter' => 'users#newsletter', :as => :user_newsletter, :via => :get

  resources :reports, :only => [:index, :new, :create, :destroy, :update, :show]

  resources :deployments, :only => [:index, :destroy]

  resources :submissions, :only => [:new, :create, :show, :index, :destroy] do
    member do
      get 'analyze'
      get 'parse'
      get 'deployments'
      get 'proposed'
      get 'retrievals'
      get 'tags'
      get 'locations'
      get 'project'
    end
  end

  # The projects controller is identical to the studies
  resources :studies, :projects, :controller => :studies, :only => [:index, :show, :edit, :update] do
    resources :deployments, :only => [:index, :destroy]
    resources :reports, :only => [:index, :destroy, :update]
  end

  match 'explore' => 'explore#index', :as => :explore, :via => :get
  match 'search' => 'search#index', :as => :search, :via => :get
  match 'search/tags' => 'search#tags', :as => :search_tags, :via => :get
  match 'search/reports' => 'search#reports', :as => :search_reports, :via => :get
  match 'search/studies' => 'search#studies', :as => :search_studies, :via => :get
  match 'search/deployments' => 'search#deployments', :as => :search_deployments, :via => :get
  match 'search/tag' => 'search#tag', :as => :tag_search, :via => :get
  match 'search/match_tags' => 'search#match_tags', :as => :multi_tag_search, :via => :get

  match 'static/:action' => 'static#:action', :as => :static, :via => :get

end
