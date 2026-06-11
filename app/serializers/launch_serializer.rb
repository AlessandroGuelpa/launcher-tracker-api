class LaunchSerializer
  def self.render(launch, detail: false)
    return nil unless launch

    result = {
      id: launch.id,
      name: launch.name,
      date_utc: launch.date_utc,
      success: launch.success,
      provider: launch.provider_name,
      rocket: launch.rocket&.name,
      pad: launch.launchpad&.name
    }

    if detail
      result[:details] = launch.details
      result[:rocket_detail] = launch.rocket ? RocketSerializer.render(launch.rocket) : nil
      result[:pad_detail] = launch.launchpad ? LaunchpadSerializer.render(launch.launchpad) : nil
    end

    result
  end
end