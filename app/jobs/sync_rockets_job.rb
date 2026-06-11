class SyncRocketsJob < ApplicationJob
  queue_as :default

  def perform
    svc = LaunchLibraryService.new
    offset = 0
    limit = 100

    loop do
      data = svc.rocket_configurations(limit: limit, offset: offset)
      break unless data

      results = data["results"]
      break if results.blank?

      results.each do |r|
        Rocket.find_or_initialize_by(external_id: r["id"].to_s).tap do |rocket|
          rocket.name         = r["name"]
          rocket.description  = r.dig("description") || r["full_name"]
          rocket.first_flight = r["maiden_flight"]
          rocket.active = r["active"] || false
          rocket.save!
        end
      end

      offset += limit
      break if offset >= data["count"]
    end

    Rails.logger.info("[SyncRocketsJob] Synced #{Rocket.count} rockets")
  end
end