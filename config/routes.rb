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

  resources :receiver_deployments, :only => [:index]

  resources :submissions, :only => [:new, :create, :show, :index, :destroy]

  # The projects controller is identical to the studies
  resources :studies, :projects, :controller => :studies, :only => [:index, :new, :create, :show, :edit, :update]

  match 'explore' => 'explore#index', :as => :explore, :via => :get
  match 'search' => 'search#index', :as => :search, :via => :get
  match 'search/tags' => 'search#tags', :as => :search_tags, :via => :get
  match 'search/reports' => 'search#reports', :as => :search_reports, :via => :get
  match 'search/studies' => 'search#studies', :as => :search_studies, :via => :get
  match 'search/receivers' => 'search#receivers', :as => :search_receivers, :via => :get
  match 'search/tag' => 'search#tag', :as => :tag_search, :via => :get
  match 'search/match_tags' => 'search#match_tags', :as => :multi_tag_search, :via => :get

  match 'static/:action' => 'static#:action', :as => :static, :via => :get

end
#== Route Map
# Generated on 04 Apr 2013 15:21
#
# batch_action_admin_receiver_deployments POST   /admin/receiver_deployments/batch_action(.:format) admin/receiver_deployments#batch_action
#              admin_receiver_deployments GET    /admin/receiver_deployments(.:format)              admin/receiver_deployments#index
#                                         POST   /admin/receiver_deployments(.:format)              admin/receiver_deployments#create
#           new_admin_receiver_deployment GET    /admin/receiver_deployments/new(.:format)          admin/receiver_deployments#new
#          edit_admin_receiver_deployment GET    /admin/receiver_deployments/:id/edit(.:format)     admin/receiver_deployments#edit
#               admin_receiver_deployment GET    /admin/receiver_deployments/:id(.:format)          admin/receiver_deployments#show
#                                         PUT    /admin/receiver_deployments/:id(.:format)          admin/receiver_deployments#update
#                                         DELETE /admin/receiver_deployments/:id(.:format)          admin/receiver_deployments#destroy
#                         admin_dashboard        /admin/dashboard(.:format)                         admin/dashboard#index
#            batch_action_admin_receivers POST   /admin/receivers/batch_action(.:format)            admin/receivers#batch_action
#                         admin_receivers GET    /admin/receivers(.:format)                         admin/receivers#index
#                                         POST   /admin/receivers(.:format)                         admin/receivers#create
#                      new_admin_receiver GET    /admin/receivers/new(.:format)                     admin/receivers#new
#                     edit_admin_receiver GET    /admin/receivers/:id/edit(.:format)                admin/receivers#edit
#                          admin_receiver GET    /admin/receivers/:id(.:format)                     admin/receivers#show
#                                         PUT    /admin/receivers/:id(.:format)                     admin/receivers#update
#                                         DELETE /admin/receivers/:id(.:format)                     admin/receivers#destroy
#                batch_action_admin_users POST   /admin/users/batch_action(.:format)                admin/users#batch_action
#                             admin_users GET    /admin/users(.:format)                             admin/users#index
#                                         POST   /admin/users(.:format)                             admin/users#create
#                          new_admin_user GET    /admin/users/new(.:format)                         admin/users#new
#                         edit_admin_user GET    /admin/users/:id/edit(.:format)                    admin/users#edit
#                              admin_user GET    /admin/users/:id(.:format)                         admin/users#show
#                                         PUT    /admin/users/:id(.:format)                         admin/users#update
#                                         DELETE /admin/users/:id(.:format)                         admin/users#destroy
#              batch_action_admin_studies POST   /admin/studies/batch_action(.:format)              admin/studies#batch_action
#                           admin_studies GET    /admin/studies(.:format)                           admin/studies#index
#                                         POST   /admin/studies(.:format)                           admin/studies#create
#                         new_admin_study GET    /admin/studies/new(.:format)                       admin/studies#new
#                        edit_admin_study GET    /admin/studies/:id/edit(.:format)                  admin/studies#edit
#                             admin_study GET    /admin/studies/:id(.:format)                       admin/studies#show
#                                         PUT    /admin/studies/:id(.:format)                       admin/studies#update
#                                         DELETE /admin/studies/:id(.:format)                       admin/studies#destroy
#      batch_action_admin_tag_deployments POST   /admin/tag_deployments/batch_action(.:format)      admin/tag_deployments#batch_action
#                   admin_tag_deployments GET    /admin/tag_deployments(.:format)                   admin/tag_deployments#index
#                                         POST   /admin/tag_deployments(.:format)                   admin/tag_deployments#create
#                new_admin_tag_deployment GET    /admin/tag_deployments/new(.:format)               admin/tag_deployments#new
#               edit_admin_tag_deployment GET    /admin/tag_deployments/:id/edit(.:format)          admin/tag_deployments#edit
#                    admin_tag_deployment GET    /admin/tag_deployments/:id(.:format)               admin/tag_deployments#show
#                                         PUT    /admin/tag_deployments/:id(.:format)               admin/tag_deployments#update
#                                         DELETE /admin/tag_deployments/:id(.:format)               admin/tag_deployments#destroy
#                 batch_action_admin_tags POST   /admin/tags/batch_action(.:format)                 admin/tags#batch_action
#                              admin_tags GET    /admin/tags(.:format)                              admin/tags#index
#                                         POST   /admin/tags(.:format)                              admin/tags#create
#                           new_admin_tag GET    /admin/tags/new(.:format)                          admin/tags#new
#                          edit_admin_tag GET    /admin/tags/:id/edit(.:format)                     admin/tags#edit
#                               admin_tag GET    /admin/tags/:id(.:format)                          admin/tags#show
#                                         PUT    /admin/tags/:id(.:format)                          admin/tags#update
#                                         DELETE /admin/tags/:id(.:format)                          admin/tags#destroy
#             batch_action_admin_comments POST   /admin/comments/batch_action(.:format)             admin/comments#batch_action
#                          admin_comments GET    /admin/comments(.:format)                          admin/comments#index
#                                         POST   /admin/comments(.:format)                          admin/comments#create
#                           admin_comment GET    /admin/comments/:id(.:format)                      admin/comments#show
#                                    root        /                                                  home#index
#                                   about GET    /about(.:format)                                   home#about
#                      acoustic_telemetry GET    /acoustic_telemetry(.:format)                      home#acoustic_telemetry
#                               have_data GET    /have_data(.:format)                               home#have_data
#                        new_user_session GET    /users/sign_in(.:format)                           devise/sessions#new
#                            user_session POST   /users/sign_in(.:format)                           devise/sessions#create
#                    destroy_user_session GET    /users/sign_out(.:format)                          devise/sessions#destroy
#                           user_password POST   /users/password(.:format)                          devise/passwords#create
#                       new_user_password GET    /users/password/new(.:format)                      devise/passwords#new
#                      edit_user_password GET    /users/password/edit(.:format)                     devise/passwords#edit
#                                         PUT    /users/password(.:format)                          devise/passwords#update
#                cancel_user_registration GET    /users/cancel(.:format)                            devise/registrations#cancel
#                       user_registration POST   /users(.:format)                                   devise/registrations#create
#                   new_user_registration GET    /users/sign_up(.:format)                           devise/registrations#new
#                  edit_user_registration GET    /users/edit(.:format)                              devise/registrations#edit
#                                         PUT    /users(.:format)                                   devise/registrations#update
#                                         DELETE /users(.:format)                                   devise/registrations#destroy
#                       user_confirmation POST   /users/confirmation(.:format)                      devise/confirmations#create
#                   new_user_confirmation GET    /users/confirmation/new(.:format)                  devise/confirmations#new
#                                         GET    /users/confirmation(.:format)                      devise/confirmations#show
#                                   users GET    /users(.:format)                                   users#index
#                                    user PUT    /users/:id(.:format)                               users#update
#                                         DELETE /users/:id(.:format)                               users#destroy
#                         user_newsletter GET    /users/newsletter(.:format)                        users#newsletter
#                                 reports GET    /reports(.:format)                                 reports#index
#                                         POST   /reports(.:format)                                 reports#create
#                              new_report GET    /reports/new(.:format)                             reports#new
#                                  report GET    /reports/:id(.:format)                             reports#show
#                                         PUT    /reports/:id(.:format)                             reports#update
#                                         DELETE /reports/:id(.:format)                             reports#destroy
#                    receiver_deployments GET    /receiver_deployments(.:format)                    receiver_deployments#index
#                             submissions GET    /submissions(.:format)                             submissions#index
#                                         POST   /submissions(.:format)                             submissions#create
#                          new_submission GET    /submissions/new(.:format)                         submissions#new
#                              submission GET    /submissions/:id(.:format)                         submissions#show
#                                         DELETE /submissions/:id(.:format)                         submissions#destroy
#                                 studies GET    /studies(.:format)                                 studies#index
#                                         POST   /studies(.:format)                                 studies#create
#                               new_study GET    /studies/new(.:format)                             studies#new
#                              edit_study GET    /studies/:id/edit(.:format)                        studies#edit
#                                   study GET    /studies/:id(.:format)                             studies#show
#                                         PUT    /studies/:id(.:format)                             studies#update
#                                projects GET    /projects(.:format)                                studies#index
#                                         POST   /projects(.:format)                                studies#create
#                             new_project GET    /projects/new(.:format)                            studies#new
#                            edit_project GET    /projects/:id/edit(.:format)                       studies#edit
#                                 project GET    /projects/:id(.:format)                            studies#show
#                                         PUT    /projects/:id(.:format)                            studies#update
#                                 explore GET    /explore(.:format)                                 explore#index
#                                  search GET    /search(.:format)                                  search#index
#                             search_tags GET    /search/tags(.:format)                             search#tags
#                          search_reports GET    /search/reports(.:format)                          search#reports
#                          search_studies GET    /search/studies(.:format)                          search#studies
#                        search_receivers GET    /search/receivers(.:format)                        search#receivers
#                              tag_search GET    /search/tag(.:format)                              search#tag
#                        multi_tag_search GET    /search/match_tags(.:format)                       search#match_tags
#                                  static GET    /static/:action(.:format)                          static#:action
