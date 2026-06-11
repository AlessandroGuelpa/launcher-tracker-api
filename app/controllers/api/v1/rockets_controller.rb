module Api
  module V1
    class RocketsController < ApplicationController
      def index
        rockets = Rocket.all
        rockets = rockets.where(active: true) if params[:active] == "true"
        rockets = rockets.order(:name)

        render json: { data: rockets.map { |r| RocketSerializer.render(r) } }
      end

      def show
        rocket = Rocket.find(params[:id])
        render json: { data: RocketSerializer.render(rocket, detail: true) }
      end
    end
  end
end