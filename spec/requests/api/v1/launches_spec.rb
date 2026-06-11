require 'swagger_helper'

RSpec.describe 'Launches API', type: :request do
  path '/api/v1/launches' do
    get 'List launches' do
      tags 'Launches'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Results per page (default 20)'
      parameter name: :q, in: :query, type: :string, required: false, description: 'Search by name or provider'
      parameter name: :provider, in: :query, type: :string, required: false, description: 'Filter by provider name (partial match)'
      parameter name: :year, in: :query, type: :integer, required: false, description: 'Filter by launch year'
      parameter name: :success, in: :query, type: :boolean, required: false, description: 'Filter by success status'
      parameter name: :rocket_id, in: :query, type: :integer, required: false, description: 'Filter by rocket ID'

      response '200', 'Returns paginated launches' do
        schema type: :object,
          properties: {
            data: { type: :array, items: { '$ref' => '#/components/schemas/launch' } },
            meta: { '$ref' => '#/components/schemas/pagination' }
          }

        let(:page) { 1 }
        run_test!
      end
    end
  end

  path '/api/v1/launches/{id}' do
    get 'Get a launch' do
      tags 'Launches'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'Returns launch details' do
        schema type: :object,
          properties: {
            data: { '$ref' => '#/components/schemas/launch' }
          }

        let(:id) { Launch.first&.id || 1 }
        run_test!
      end

      response '404', 'Launch not found' do
        let(:id) { 999999 }
        run_test!
      end
    end
  end

  path '/api/v1/launches/upcoming' do
    get 'Upcoming launches' do
      tags 'Launches'
      produces 'application/json'
      parameter name: :limit, in: :query, type: :integer, required: false, description: 'Max results (default 10)'

      response '200', 'Returns upcoming launches' do
        schema type: :object,
          properties: {
            data: { type: :array, items: { '$ref' => '#/components/schemas/launch' } }
          }

        run_test!
      end
    end
  end

  path '/api/v1/launches/latest' do
    get 'Latest completed launch' do
      tags 'Launches'
      produces 'application/json'

      response '200', 'Returns the most recent completed launch' do
        schema type: :object,
          properties: {
            data: { '$ref' => '#/components/schemas/launch' }
          }

        run_test!
      end
    end
  end
end
