class LaunchLibraryService
  # lldev = dev environment, nessun rate limit, dati leggermente stale
  # ll    = production, 15 req/ora senza API key
  BASE_URL = "https://lldev.thespacedevs.com/2.3.0/"

  def initialize
    @conn = Faraday.new(url: BASE_URL) do |f|
      f.request :json
      f.response :json
      f.response :raise_error
      f.adapter Faraday.default_adapter
    end
  end

  def rocket_configurations(limit: 100, offset: 0)
    get("launcher_configurations/", { limit: limit, offset: offset })
  end

  def pads(limit: 100, offset: 0)
    get("pads/", { limit: limit, offset: offset })
  end

  def launches(limit: 50, offset: 0)
    get("launches/", { limit: limit, offset: offset, ordering: "-net" })
  end

  def upcoming_launches(limit: 50, offset: 0)
    get("launches/upcoming/", { limit: limit, offset: offset, ordering: "net" })
  end

  def previous_launches(limit: 50, offset: 0)
    get("launches/previous/", { limit: limit, offset: offset, ordering: "-net" })
  end

  def next_launch
    upcoming_launches(limit: 1)&.dig("results", 0)
  end

  def latest_launch
    previous_launches(limit: 1)&.dig("results", 0)
  end

  private

  # path SENZA leading slash — con leading slash Faraday scarta /2.3.0/
  def get(path, params = {})
    @conn.get(path, params).body
  rescue Faraday::Error => e
    Rails.logger.error("[LaunchLibraryService] GET #{path} failed: #{e.message}")
    nil
  end
end