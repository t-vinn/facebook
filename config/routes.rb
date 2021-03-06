# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root 'users/users#index'
  namespace :users do
    resources :users, only: [:index, :show]
    resources :follow_relationships, only: [:create, :destroy]
    resources :groups, except: [:new, :destroy] do
      resources :groups_users, only: [:create, :destroy], module: :groups
      resources :group_posts, only: [:create, :destroy], module: :groups do
        resources :group_post_favorites, only: [:create, :destroy], module: :group_posts
      end
    end
    resources :feeds, only: [:create, :edit, :update] do
      resources :replies, only: [:new, :create], module: :feeds do
        resources :reply_favorites, only: [:create, :destroy], module: :replies
      end
      resources :feed_favorites, only: [:create, :destroy], module: :feeds
    end
  end

  match '*path' => 'application#render_404', via: :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
