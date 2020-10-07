require 'swagger_helper'

describe 'Collections Resources API' do
  path '/api/collections/{uuid}/resources' do
    get 'Get the list of all resources for a collection' do
      tags 'Collections'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Collection you wish to access', required: true
      parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
      parameter name: :filter, in: :query, type: :string, description: 'a string to filter the returned resources by name', required: false
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:collection) { create(:collection) }
        let(:uuid) { collection.uuid }
        let!(:resource_1) { create(:resource, collection: collection) }
        let!(:resource_2) { create(:resource, collection: collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        schema type: :array,
               items: { '$ref' => '#/definitions/resource' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(2)
        end
      end

      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:collection) { create(:collection) }
        let(:uuid) { collection.uuid }
        let!(:resource_1) { create(:resource, collection: collection) }
        let!(:resource_matching_filter) { create(:resource, collection: collection, name: 'match_this_filter') }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:filter) { 'match_this_filter' }
        schema type: :array,
               items: { '$ref' => '#/definitions/resource' }
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(1)
          expect(response.body).to include(resource_matching_filter.name)
        end
      end

      response '401', 'unauthorised access to this resource\'s collection' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:collection).uuid }
        run_test!
      end

      response '404', 'Collection not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end
    end

    get 'Get the list of all resources for a collection for an unauthenticated user' do
      tags 'Collections'
      produces 'application/json'
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Collection you wish to access', required: true
      parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
      parameter name: :filter, in: :query, type: :string, description: 'a string to filter the returned resources by name', required: false
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let!(:public_collection) { create(:collection, :with_public_access) }
        let(:uuid) { public_collection.uuid }
        let!(:resource_1) { create(:resource, collection: public_collection) }
        let!(:resource_2) { create(:resource, collection: public_collection) }
        schema type: :array,
               items: { '$ref' => '#/definitions/resource' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(2)
        end
      end

      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let!(:public_collection) { create(:collection, :with_public_access) }
        let(:uuid) { public_collection.uuid }
        let!(:resource_1) { create(:resource, collection: public_collection) }
        let!(:resource_matching_filter) { create(:resource, collection: public_collection, name: 'match_this_filter') }
        let(:filter) { 'match_this_filter' }
        schema type: :array,
               items: { '$ref' => '#/definitions/resource' }
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(1)
          expect(response.body).to include(resource_matching_filter.name)
        end
      end

      response '401', 'unauthorised access to this resource\'s collection' do
        let(:uuid) { create(:collection).uuid }
        run_test!
      end

      response '404', 'Collection not found' do
        let(:uuid) { 'invalid' }
        run_test!
      end
    end
  end
end
