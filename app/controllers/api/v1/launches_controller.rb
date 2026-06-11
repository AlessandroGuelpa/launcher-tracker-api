module Api
  module V1
    class LaunchesController < ApplicationController
      def index
        launches = Launch.includes(:rocket, :launchpad)
        launches = apply_filters(launches)
        launches = launches.order(date_utc: :desc).page(params[:page]).per(params[:per_page] || 20)

        render json: {
          data: launches.map { |l| LaunchSerializer.render(l) },
          meta: pagination_meta(launches)
        }
      end

      def show
        launch = Launch.includes(:rocket, :launchpad).find(params[:id])
        render json: { data: LaunchSerializer.render(launch, detail: true) }
      end

      def upcoming
        launches = Launch.includes(:rocket, :launchpad)
                        .where(success: nil)
                        .where("date_utc > ?", Time.current)
                        .order(date_utc: :asc)
                        .limit(params[:limit] || 10)

        render json: { data: launches.map { |l| LaunchSerializer.render(l) } }
      end

      def latest
        launch = Launch.includes(:rocket, :launchpad)
                       .where.not(success: nil)
                       .order(date_utc: :desc)
                       .first

        render json: { data: LaunchSerializer.render(launch, detail: true) }
      end

      private

      def apply_filters(scope)
        scope = scope.where(provider_name: params[:provider]) if params[:provider].present?
        scope = scope.where(rocket_id: params[:rocket_id])    if params[:rocket_id].present?
        scope = scope.where(success: params[:success])        if params[:success].present?

        if params[:year].present?
          year = params[:year].to_i
          scope = scope.where(date_utc: Time.utc(year)..Time.utc(year + 1))
        end

        scope
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end