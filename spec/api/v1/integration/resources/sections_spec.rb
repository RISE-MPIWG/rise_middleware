require 'swagger_helper'

describe 'Resources / Sections API' do
  path '/api/resources/{uuid}/sections' do
    get 'Get the list of all sections for a resource' do
      tags 'Resources'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Resource you wish to access', required: true
      parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
      parameter name: :filter, in: :query, type: :string, description: 'a string to filter the returned sections by title', required: false
      response '200', 'OK' do
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let!(:resource) { create(:resource, collection: collection) }
        let(:uuid) { resource.uuid }
        let!(:sections) { create_list(:section, 6, resource: resource) }
        schema type: :array,
               items: { '$ref' => '#/definitions/section' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(6)
        end
      end

      response '200', 'OK' do
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let!(:resource) { create(:resource, collection: collection) }
        let(:uuid) { resource.uuid }
        let!(:sections) { create_list(:section, 2, resource: resource) }
        let!(:section_matching_filter) { create(:section, resource: resource, name: 'match_this_filter') }
        let(:filter) { 'match_this_filter' }
        schema type: :array,
               items: { '$ref' => '#/definitions/section' }
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(1)
          expect(response.body).to include(section_matching_filter.name)
        end
      end

      response '401', 'unauthorised access to this resource' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:resource).uuid }
        run_test!
      end

      response '404', 'resource not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end
    end
  end
end
