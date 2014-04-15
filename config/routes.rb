Web::Application.routes.draw do


  resources :contacts


  devise_for :users, path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" },
  controllers: { omniauth_callbacks: "authentications", registrations: "registrations"  }
  match "/contacts/:importer/callback" => "contacts#show"
  get "/contacts/failure" => "contacts#failure"
  post "/contacts" => "contacts#create"
  
  resources :users
  resources :package_responses, :only => [:create, :index]
  
  root :to => 'home#index'
  post "/home_request" => "home#create"

  get 'privacy' => 'home#privacy'
  get 'terms' => 'home#terms'
  
  
  post 'users/:id' => 'users#update'
  get 'confirm' => 'users#confirm'
  get 'thanks' => 'users#thanks'

  get 'events/:id/invitee/:uid' => 'events#show'
  post 'events/:id/invitee/:uid' => 'events#invite_response'

  constraints :format => 'json' do
    namespace :api, :defaults => { :format => 'json' } do
      namespace :v1 do
        resources :venues, :only => [:index]
        resources :events, :only => [:index, :show, :create] do

          resources :event_times, :path => 'times', :only => [:create, :index]
          get 'times/options' => 'event_times#options'

          resources :event_packages, :path => 'packages', :only => [:create, :index]
          get 'packages/options' => 'event_packages#options'

          put 'invitees' => 'invitees#update'
        end

        resources :packages, :only => [:index] do
        end
      end
    end
  end
end
