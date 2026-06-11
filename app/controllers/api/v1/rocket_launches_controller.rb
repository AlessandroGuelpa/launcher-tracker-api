module Api
  module V1
    class RocketLaunchesController < ApplicationController
      def index
        rocket = Rocket.find(params[:rocket_id])
        launches = rocket.launches.includes(:launchpad)
                        .order(date_utc: :desc)
                        .limit(params[:limit] || 20)

        render json: { data: launches.map { |l| LaunchSerializer.render(l) } }
      end
    end
  end
end