module Api
  module V1
    class StatsController < ApplicationController
      def launches_per_year
        data = Launch.where.not(date_utc: nil)
                     .group("YEAR(date_utc)")
                     .order("YEAR(date_utc)")
                     .count

        render json: { data: data }
      end

      def success_rate
        total    = Launch.where.not(success: nil).count
        success  = Launch.where(success: true).count
        failure  = Launch.where(success: false).count

        per_rocket = Rocket.joins(:launches)
                          .where.not(launches: { success: nil })
                          .group("rockets.name")
                          .select(
                            "rockets.name",
                            "COUNT(*) as total",
                            "SUM(CASE WHEN launches.success = true THEN 1 ELSE 0 END) as successes"
                          )
                          .map do |r|
                            {
                              rocket: r.name,
                              total: r.total,
                              successes: r.successes,
                              rate: (r.successes.to_f / r.total * 100).round(2)
                            }
                          end

        render json: {
          data: {
            overall: { total: total, successes: success, failures: failure, rate: total > 0 ? (success.to_f / total * 100).round(2) : 0 },
            per_rocket: per_rocket.sort_by { |r| -r[:total] }.first(20)
          }
        }
      end

      def streak
        launches = Launch.where.not(success: nil).order(date_utc: :desc)
        current_streak = 0

        launches.each do |l|
          break unless l.success
          current_streak += 1
        end

        render json: { data: { current_success_streak: current_streak } }
      end

      def providers
        data = Launch.where.not(provider_name: nil)
                     .group(:provider_name)
                     .order("count_all DESC")
                     .count

        render json: { data: data }
      end
    end
  end
end