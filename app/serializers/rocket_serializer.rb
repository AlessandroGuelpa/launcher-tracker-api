class RocketSerializer
  def self.render(rocket, detail: false)
    return nil unless rocket

    result = {
      id: rocket.id,
      name: rocket.name,
      active: rocket.active,
      first_flight: rocket.first_flight
    }

    if detail
      result[:description] = rocket.description
      result[:total_launches] = rocket.launches.count
      result[:success_count] = rocket.launches.where(success: true).count
    end

    result
  end
end