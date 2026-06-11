require 'swagger_helper'

RSpec.describe 'Stats API', type: :request do
  path '/api/v1/stats/launches_per_year' do
    get 'Launches per year' do
      tags 'Statistics'
      produces 'application/json'

      response '200', 'Returns launch count grouped by year' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              additionalProperties: { type: :integer },
              example: { '2024' => 220, '2025' => 250 }
            }
          }

        run_test!
      end
    end
  end

  path '/api/v1/stats/success_rate' do
    get 'Success rate' do
      tags 'Statistics'
      produces 'application/json'

      response '200', 'Returns overall and per-rocket success rates' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                overall: {
                  type: :object,
                  properties: {
                    total: { type: :integer },
                    successes: { type: :integer },
                    failures: { type: :integer },
                    rate: { type: :number, format: :float }
                  }
                },
                per_rocket: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      rocket: { type: :string },
                      total: { type: :integer },
                      successes: { type: :integer },
                      rate: { type: :number, format: :float }
                    }
                  }
                }
              }
            }
          }

        run_test!
      end
    end
  end

  path '/api/v1/stats/streak' do
    get 'Current success streak' do
      tags 'Statistics'
      produces 'application/json'

      response '200', 'Returns current consecutive success count' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                current_success_streak: { type: :integer }
              }
            }
          }

        run_test!
      end
    end
  end

  path '/api/v1/stats/providers' do
    get 'Launches by provider' do
      tags 'Statistics'
      produces 'application/json'

      response '200', 'Returns launch count per provider' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              additionalProperties: { type: :integer }
            }
          }

        run_test!
      end
    end
  end
end
