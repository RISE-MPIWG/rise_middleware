require 'api_constraints'

Rails.application.routes.draw do
  resources :research_tools
  resources :contacts, only: [:create]

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:super_admin?) && current_user.super_admin?
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/resque_web"
  end

  mount ActionCable.server => '/cable'

  mount Rswag::Api::Engine => '/api-docs'
  resources :collections
  resources :resources do
    member do
      get :sections_for_tree_display
      patch :edit_tags
    end
  end
  resources :organisations
  resources :user
  resources :sections, only: %i[show]

  get :shibbo_callback, :to => 'shibbo#index'

  resources :corpora do
    member do
      get :tools
      post :tools
      get :pull_full_text
    end
    resources :resources, controller: 'corpora/resources' do
      member do
        get :add
        get :remove
        get :pull_full_text
      end
    end
    member do
      get :add_resources
    end
  end

  resources :tool_exports, only: %i[index new create show] do
    member do
      get :download
    end
  end

  authenticate :user do
    namespace 'admin' do
      resources :users do
        member do
          get :refresh_api_token
        end
      end
      get 'monitor_jobs', to: 'monitor_jobs#index'
      resources :user_logs, only: [:index]
      resources :organisations do
        member do
          patch :scrap_collections
        end
      end
      resources :research_tools do
        resources :organisations, controller: 'research_tools/organisations' do
          member do
            put :set_access
          end
        end
        member do
          get :manage_access
          get :download_api_definition_file
          get :api_definition
          patch :update_api_definition_file
        end
      end

      resources :resources do
        member do
          get :request_access
        end
      end

      resources :research_tools, only: [:index]

      resources :collections do
        collection do
          get :refresh_all_indexes
        end
        resources :resources, controller: 'collections/resources' do
          collection do
            get :refresh_index
          end
          member do
            get :pull_full_text
          end
        end
        resources :organisations, controller: 'collections/organisations' do
          member do
            put :set_access
          end
        end
        resources :endpoint_maps, controller: 'collections/endpoint_maps' do
          member do
            patch :set_response_properties_map
            get :execute
            get :mappable_route
            get :footprint_values
          end
        end
        resources :research_tools, controller: 'collections/research_tools' do
          member do
            put :set_access
          end
        end
        member do
          get :manage_organisation_access
          get :manage_research_tool_access
          get :download_api_definition_file
          get :api_definition
          get :mapping
          patch :update_api_definition_file
        end
      end
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  root 'pages#index'

  resources :pages do
    collection do
      get :about
      get :coc
      get :shine_api
      get :rise
      get :community
      get :imprint
      get :sbb_auth
      get :sbb_auth_callback
      get :sbb_auth_token_callback
      get :search
      get :doc_for_resource_providers
      get :doc_for_developers
    end
  end

  namespace :api do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # sign in/out
      resources :rp_services, only: %i{}, controller: 'rp_services' do
        collection do
          post :register_instance
        end
      end

      as :user do
        post   '/sign_in'  => "sessions#create"
        delete '/sign_out' => "sessions#destroy"
      end
      resources :collections, param: :uuid, only: %i{index show} do
        member do 
          get :metadata
        end
        resources :resources, only: %i{index}, controller: 'collections/resources' do
        end
        resources :research_tools, only: %i{index}, controller: 'collections/research_tools' do
        end
      end

      resources :research_tools, param: :uuid, only: %i{index show} do
        member do
          post :sections_import_url
        end
      end

      resources :tool_exports, param: :uuid, only: %i{index show create} do
      end

      resources :corpora, param: :uuid, only: %i{index show} do
        resources :resources, only: %i{index}, controller: 'corpora/resources' do
        end
      end
      resources :resources, param: :uuid, only: %i{index show} do
        member do
          get :metadata
        end
        resources :sections, only: %i{index}, controller: 'resources/sections'
      end
      resources :sections, param: :uuid, only: %i{index show} do
        member do
          get :metadata
        end
        resources :content_units, only: %i{index}, controller: 'sections/content_units' do
        end
      end
      resources :content_units, param: :uuid, only: %i{show} do
        member do
          get :metadata
        end
      end
    end
  end
end
