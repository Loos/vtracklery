require 'api_constraints'
module Routes
  module ApiRoutes

    def self.draw(context)
      context.instance_eval do

        concern :api_v1 do
          scope :backup, controller: 'backup' do
            get :surveys
            get :events
            get :workers
            get :work_times
            get :work_statuses
            get :statuses
          end

          scope :report, controller: 'report' do
            get "hours", as: "hours_current", to: "report#hours"
            get "hours/:year/:month/:day", as: "day_hours", to: "report#day_hours"
            get "workers", as: "workers_current", to: "report#workers"
            get "workers/:year/:month/:day", as: "day_workers", to: "report#day_workers"
            get "weekof", as: "weekof_current", to: "report#weekof"
            get "weekof/:year/:month/:day", as: "weekof", to: "report#weekof"
          end

          resources :workers do
            collection do
              get :missing
              get :regular
              get :shop
              get :where
            end
            member do
              post :clock_in
              post :clock_out
              get :email
              get :phone
              get :status
            end
          end

          resources :work_times do
            collection do
              get :logged_in
              get :too_long
              get :mismatched_dates

              get :week
              get :month
              get :year
            end
          end

          resources :surveys
          resources :events

        end

        namespace :api, defaults: {format: 'json'} do
          scope(:module => :v1,
                constraints: ApiConstraints.new(version: 1, default: true)) do
            concerns :api_v1
          end
          namespace :v1 do
            concerns :api_v1
          end
        end

      end
    end
  end
end
