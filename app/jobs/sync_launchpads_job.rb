class SyncLaunchpadsJob < ApplicationJob
  queue_as :default

  def perform
    svc = LaunchLibraryService.new
    offset = 0
    limit = 100

    loop do
      data = svc.pads(limit: limit, offset: offset)
      break unless data

      results = data["results"]
      break if results.blank?

      results.each do |p|
        Launchpad.find_or_initialize_by(external_id: p["id"].to_s).tap do |pad|
          pad.name      = p["name"]
          pad.full_name = p.dig("location", "name")
          pad.locality  = p.dig("location", "country", "name") || p.dig("location", "name")
          pad.region    = p.dig("location", "country", "name")
          pad.latitude  = p["latitude"]
          pad.longitude = p["longitude"]
          pad.save!
        end
      end

      offset += limit
      break if offset >= data["count"]
    end

    Rails.logger.info("[SyncLaunchpadsJob] Synced #{Launchpad.count} pads")
  end
end