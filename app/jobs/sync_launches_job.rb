class SyncLaunchesJob < ApplicationJob
  queue_as :default

  def perform(scope: "previous", limit: 100)
    svc = LaunchLibraryService.new
    offset = 0

    loop do
      data = case scope
             when "previous" then svc.previous_launches(limit: limit, offset: offset)
             when "upcoming" then svc.upcoming_launches(limit: limit, offset: offset)
             else svc.launches(limit: limit, offset: offset)
             end

      break unless data

      results = data["results"]
      break if results.blank?

      results.each { |l| upsert_launch(l) }

      offset += limit
      break if offset >= data["count"]

      # rispetta rate limit in produzione
      sleep(1) if ENV["LL2_BASE_URL"]&.include?("ll.thespacedevs.com")
    end

    Rails.logger.info("[SyncLaunchesJob] scope=#{scope} — Total launches: #{Launch.count}")
  end

  private

  def upsert_launch(data)
    rocket = find_or_create_rocket(data.dig("rocket", "configuration"))
    pad    = find_or_create_pad(data["pad"])

    Launch.find_or_initialize_by(external_id: data["id"]).tap do |launch|
      launch.name          = data["name"]
      launch.date_utc      = data["net"]
      launch.success       = resolve_success(data.dig("status", "id"))
      launch.details       = data.dig("mission", "description")
      launch.provider_name = data.dig("launch_service_provider", "name")
      launch.rocket        = rocket
      launch.launchpad     = pad
      launch.raw_data      = data
      launch.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.warn("[SyncLaunchesJob] Skip #{data['id']}: #{e.message}")
  end

  def resolve_success(status_id)
    case status_id
    when 3 then true       # Launch Successful
    when 4, 7 then false   # Launch Failure, Launch Partial Failure
    else nil               # Go, TBD, TBC, etc.
    end
  end

  def find_or_create_rocket(config)
    return nil unless config

    Rocket.find_or_create_by!(external_id: config["id"].to_s) do |r|
      r.name = config["name"]
    end
  end

  def find_or_create_pad(pad_data)
    return nil unless pad_data

    Launchpad.find_or_create_by!(external_id: pad_data["id"].to_s) do |p|
      p.name      = pad_data["name"]
      p.latitude  = pad_data["latitude"]
      p.longitude = pad_data["longitude"]
    end
  end
end