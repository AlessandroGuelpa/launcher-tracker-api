require 'swagger_helper'

RSpec.describe 'Rockets API', type: :request do
  path '/api/v1/rockets' do
    get 'List rockets' do
      tags 'Rockets'
      produces 'application/json'
      parameter name: :active, in: :query, type: :string, required: false, description: 'Filter active rockets (true/false)'

      response '200', 'Returns rockets' do
        schema type: :object,
          properties: {
            data: { type: :array, items: { '$ref' => '#/components/schemas/rocket' } }
          }

        run_test!
      end
    end
  end

  path '/api/v1/rockets/{id}' do
    get 'Get a rocket' do
      tags 'Rockets'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'Returns rocket details' do
        let(:id) { Rocket.first&.id || 1 }
        run_test!
      end

      response '404', 'Rocket not found' do
        let(:id) { 999999 }
        run_test!
      end
    end
  end

  path '/api/v1/rockets/{rocket_id}/launches' do
    get 'Launches for a rocket' do
      tags 'Rockets'
      produces 'application/json'
      parameter name: :rocket_id, in: :path, type: :integer, required: true
      parameter name: :limit, in: :query, type: :integer, required: false

      response '200', 'Returns launches for the rocket' do
        let(:rocket_id) { Rocket.first&.id || 1 }
        run_test!
      end
    end
  end
end
