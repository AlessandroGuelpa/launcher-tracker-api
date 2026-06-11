class LaunchpadSerializer
  def self.render(pad)
    return nil unless pad

    {
      id: pad.id,
      name: pad.name,
      full_name: pad.full_name,
      locality: pad.locality,
      latitude: pad.latitude,
      longitude: pad.longitude
    }
  end
end