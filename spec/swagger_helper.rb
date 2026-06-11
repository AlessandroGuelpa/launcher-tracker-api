require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Launch Tracker API',
        version: 'v1',
        description: 'Global orbital launch data aggregated from Launch Library 2. Built with Rails 8.1 API-only.',
        contact: {
          name: 'Alessandro Guelpa',
          url: 'https://alessandroguelpa.it'
        }
      },
      servers: [
        { url: 'http://localhost:3000', description: 'Development' }
      ],
      components: {
        schemas: {
          launch: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              date_utc: { type: :string, format: 'date-time' },
              success: { type: :boolean, nullable: true },
              provider: { type: :string, nullable: true },
              rocket: { type: :string, nullable: true },
              pad: { type: :string, nullable: true }
            }
          },
          rocket: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              active: { type: :boolean },
              first_flight: { type: :string, format: 'date', nullable: true }
            }
          },
          pagination: {
            type: :object,
            properties: {
              current_page: { type: :integer },
              total_pages: { type: :integer },
              total_count: { type: :integer }
            }
          }
        }
      }
    }
  }

  config.openapi_format = :yaml
end
