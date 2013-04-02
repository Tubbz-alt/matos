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

  resources :submissions, :only => [:new, :create, :show, :index, :destroy]

  # The projects controller is identical to the studies
  resources :studies, :projects, :controller => :studies, :only => [:index, :new, :create, :show, :edit, :update] do
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
#== Route Map
# Generated on 11 Mar 2013 14:27
#
#                    admin_dashboard        /admin/dashboard(.:format)                      admin/dashboard#index
#           batch_action_admin_users POST   /admin/users/batch_action(.:format)             admin/users#batch_action
#                        admin_users GET    /admin/users(.:format)                          admin/users#index
#                                    POST   /admin/users(.:format)                          admin/users#create
#                     new_admin_user GET    /admin/users/new(.:format)                      admin/users#new
#                    edit_admin_user GET    /admin/users/:id/edit(.:format)                 admin/users#edit
#                         admin_user GET    /admin/users/:id(.:format)                      admin/users#show
#                                    PUT    /admin/users/:id(.:format)                      admin/users#update
#                                    DELETE /admin/users/:id(.:format)                      admin/users#destroy
#         batch_action_admin_studies POST   /admin/studies/batch_action(.:format)           admin/studies#batch_action
#                      admin_studies GET    /admin/studies(.:format)                        admin/studies#index
#                                    POST   /admin/studies(.:format)                        admin/studies#create
#                    new_admin_study GET    /admin/studies/new(.:format)                    admin/studies#new
#                   edit_admin_study GET    /admin/studies/:id/edit(.:format)               admin/studies#edit
#                        admin_study GET    /admin/studies/:id(.:format)                    admin/studies#show
#                                    PUT    /admin/studies/:id(.:format)                    admin/studies#update
#                                    DELETE /admin/studies/:id(.:format)                    admin/studies#destroy
# batch_action_admin_tag_deployments POST   /admin/tag_deployments/batch_action(.:format)   admin/tag_deployments#batch_action
#              admin_tag_deployments GET    /admin/tag_deployments(.:format)                admin/tag_deployments#index
#                                    POST   /admin/tag_deployments(.:format)                admin/tag_deployments#create
#           new_admin_tag_deployment GET    /admin/tag_deployments/new(.:format)            admin/tag_deployments#new
#          edit_admin_tag_deployment GET    /admin/tag_deployments/:id/edit(.:format)       admin/tag_deployments#edit
#               admin_tag_deployment GET    /admin/tag_deployments/:id(.:format)            admin/tag_deployments#show
#                                    PUT    /admin/tag_deployments/:id(.:format)            admin/tag_deployments#update
#                                    DELETE /admin/tag_deployments/:id(.:format)            admin/tag_deployments#destroy
#     batch_action_admin_deployments POST   /admin/deployments/batch_action(.:format)       admin/deployments#batch_action
#                  admin_deployments GET    /admin/deployments(.:format)                    admin/deployments#index
#                                    POST   /admin/deployments(.:format)                    admin/deployments#create
#               new_admin_deployment GET    /admin/deployments/new(.:format)                admin/deployments#new
#              edit_admin_deployment GET    /admin/deployments/:id/edit(.:format)           admin/deployments#edit
#                   admin_deployment GET    /admin/deployments/:id(.:format)                admin/deployments#show
#                                    PUT    /admin/deployments/:id(.:format)                admin/deployments#update
#                                    DELETE /admin/deployments/:id(.:format)                admin/deployments#destroy
#            batch_action_admin_tags POST   /admin/tags/batch_action(.:format)              admin/tags#batch_action
#                         admin_tags GET    /admin/tags(.:format)                           admin/tags#index
#                                    POST   /admin/tags(.:format)                           admin/tags#create
#                      new_admin_tag GET    /admin/tags/new(.:format)                       admin/tags#new
#                     edit_admin_tag GET    /admin/tags/:id/edit(.:format)                  admin/tags#edit
#                          admin_tag GET    /admin/tags/:id(.:format)                       admin/tags#show
#                                    PUT    /admin/tags/:id(.:format)                       admin/tags#update
#                                    DELETE /admin/tags/:id(.:format)                       admin/tags#destroy
#        batch_action_admin_comments POST   /admin/comments/batch_action(.:format)          admin/comments#batch_action
#                     admin_comments GET    /admin/comments(.:format)                       admin/comments#index
#                                    POST   /admin/comments(.:format)                       admin/comments#create
#                      admin_comment GET    /admin/comments/:id(.:format)                   admin/comments#show
#                               root        /                                               home#index
#                              about GET    /about(.:format)                                home#about
#                 acoustic_telemetry GET    /acoustic_telemetry(.:format)                   home#acoustic_telemetry
#                          have_data GET    /have_data(.:format)                            home#have_data
#                   new_user_session GET    /users/sign_in(.:format)                        devise/sessions#new
#                       user_session POST   /users/sign_in(.:format)                        devise/sessions#create
#               destroy_user_session GET    /users/sign_out(.:format)                       devise/sessions#destroy
#                      user_password POST   /users/password(.:format)                       devise/passwords#create
#                  new_user_password GET    /users/password/new(.:format)                   devise/passwords#new
#                 edit_user_password GET    /users/password/edit(.:format)                  devise/passwords#edit
#                                    PUT    /users/password(.:format)                       devise/passwords#update
#           cancel_user_registration GET    /users/cancel(.:format)                         devise/registrations#cancel
#                  user_registration POST   /users(.:format)                                devise/registrations#create
#              new_user_registration GET    /users/sign_up(.:format)                        devise/registrations#new
#             edit_user_registration GET    /users/edit(.:format)                           devise/registrations#edit
#                                    PUT    /users(.:format)                                devise/registrations#update
#                                    DELETE /users(.:format)                                devise/registrations#destroy
#                  user_confirmation POST   /users/confirmation(.:format)                   devise/confirmations#create
#              new_user_confirmation GET    /users/confirmation/new(.:format)               devise/confirmations#new
#                                    GET    /users/confirmation(.:format)                   devise/confirmations#show
#                              users GET    /users(.:format)                                users#index
#                               user PUT    /users/:id(.:format)                            users#update
#                                    DELETE /users/:id(.:format)                            users#destroy
#                    user_newsletter GET    /users/newsletter(.:format)                     users#newsletter
#                            reports GET    /reports(.:format)                              reports#index
#                                    POST   /reports(.:format)                              reports#create
#                         new_report GET    /reports/new(.:format)                          reports#new
#                             report GET    /reports/:id(.:format)                          reports#show
#                                    PUT    /reports/:id(.:format)                          reports#update
#                                    DELETE /reports/:id(.:format)                          reports#destroy
#                        deployments GET    /deployments(.:format)                          deployments#index
#                         deployment DELETE /deployments/:id(.:format)                      deployments#destroy
#                 analyze_submission GET    /submissions/:id/analyze(.:format)              submissions#analyze
#                   parse_submission GET    /submissions/:id/parse(.:format)                submissions#parse
#             deployments_submission GET    /submissions/:id/deployments(.:format)          submissions#deployments
#                proposed_submission GET    /submissions/:id/proposed(.:format)             submissions#proposed
#              retrievals_submission GET    /submissions/:id/retrievals(.:format)           submissions#retrievals
#                    tags_submission GET    /submissions/:id/tags(.:format)                 submissions#tags
#               locations_submission GET    /submissions/:id/locations(.:format)            submissions#locations
#                 project_submission GET    /submissions/:id/project(.:format)              submissions#project
#                        submissions GET    /submissions(.:format)                          submissions#index
#                                    POST   /submissions(.:format)                          submissions#create
#                     new_submission GET    /submissions/new(.:format)                      submissions#new
#                         submission GET    /submissions/:id(.:format)                      submissions#show
#                                    DELETE /submissions/:id(.:format)                      submissions#destroy
#                  study_deployments GET    /studies/:study_id/deployments(.:format)        deployments#index
#                   study_deployment DELETE /studies/:study_id/deployments/:id(.:format)    deployments#destroy
#                      study_reports GET    /studies/:study_id/reports(.:format)            reports#index
#                       study_report PUT    /studies/:study_id/reports/:id(.:format)        reports#update
#                                    DELETE /studies/:study_id/reports/:id(.:format)        reports#destroy
#                            studies GET    /studies(.:format)                              studies#index
#                         edit_study GET    /studies/:id/edit(.:format)                     studies#edit
#                              study GET    /studies/:id(.:format)                          studies#show
#                                    PUT    /studies/:id(.:format)                          studies#update
#                project_deployments GET    /projects/:project_id/deployments(.:format)     deployments#index
#                 project_deployment DELETE /projects/:project_id/deployments/:id(.:format) deployments#destroy
#                    project_reports GET    /projects/:project_id/reports(.:format)         reports#index
#                     project_report PUT    /projects/:project_id/reports/:id(.:format)     reports#update
#                                    DELETE /projects/:project_id/reports/:id(.:format)     reports#destroy
#                           projects GET    /projects(.:format)                             studies#index
#                       edit_project GET    /projects/:id/edit(.:format)                    studies#edit
#                            project GET    /projects/:id(.:format)                         studies#show
#                                    PUT    /projects/:id(.:format)                         studies#update
#                            explore GET    /explore(.:format)                              explore#index
#                             search GET    /search(.:format)                               search#index
#                        search_tags GET    /search/tags(.:format)                          search#tags
#                     search_reports GET    /search/reports(.:format)                       search#reports
#                     search_studies GET    /search/studies(.:format)                       search#studies
#                 search_deployments GET    /search/deployments(.:format)                   search#deployments
#                         tag_search GET    /search/tag(.:format)                           search#tag
#                   multi_tag_search GET    /search/match_tags(.:format)                    search#match_tags
#                             static GET    /static/:action(.:format)                       static#:action
