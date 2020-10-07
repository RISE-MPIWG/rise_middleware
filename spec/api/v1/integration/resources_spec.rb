require 'swagger_helper'

describe 'Resources API' do
  path '/api/resources' do
    get 'Get the list of all resources available to the current user' do
      tags 'Resources'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
      parameter name: :filter, in: :query, type: :string, description: 'a string to filter the returned resources by name', required: false
      response '200', 'OK' do
        let!(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let!(:resources_list) { create_list(:resource, 5, collection: collection) }
        let(:inaccessible_resource) { create(:resource) }
        schema type: :array,
               items: { '$ref' => '#/definitions/resource_for_index' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(5)
          expect(response.body).to_not include(inaccessible_resource.uuid)
        end
      end

      response '200', 'OK' do
        let!(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let!(:resources_list) { create_list(:resource, 2, collection: collection) }
        let!(:resource_matching_filter) { create(:resource, collection: collection, name: 'match_this_filter') }
        let(:filter) { 'match_this_filter' }
        schema type: :array,
               items: { '$ref' => '#/definitions/resource_for_index' }
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(1)
          expect(response.body).to include(resource_matching_filter.name)
        end
      end
    end

    get 'Get the list of all resources available to an unauthenticated user' do
      tags 'Resources'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
      parameter name: :filter, in: :query, type: :string, description: 'a string to filter the returned resources by name', required: false
      response '200', 'OK' do
        let!(:organisation) { create(:organisation) }
        let!(:public_collection) { create(:collection, :with_public_access) }
        let!(:resources_list) { create_list(:resource, 5, collection: public_collection) }
        let(:inaccessible_resource) { create(:resource) }
        schema type: :array,
               items: { '$ref' => '#/definitions/resource_for_index' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(5)
          expect(response.body).to_not include(inaccessible_resource.uuid)
        end
      end

      response '200', 'OK' do
        let!(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:public_collection) { create(:collection, :with_public_access) }
        let!(:resources_list) { create_list(:resource, 2, collection: public_collection) }
        let!(:resource_matching_filter) { create(:resource, collection: public_collection, name: 'match_this_filter') }
        let(:filter) { 'match_this_filter' }
        schema type: :array,
               items: { '$ref' => '#/definitions/resource_for_index' }
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(1)
          expect(response.body).to include(resource_matching_filter.name)
        end
      end
    end
  end

  path '/api/resources/{uuid}' do
    get 'Retrieves a resource' do
      tags 'Resources'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Resource you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:resource) { create(:resource, :with_contents, collection: collection) }
        let(:uuid) { resource.uuid }
        schema '$ref' => '#/definitions/resource'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(resource.uuid)
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

  path '/api/resources/{uuid}/metadata' do
    get 'Returns a json object containing a resource\'s metadata' do
      tags 'Resources'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Resource you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:resource) { create(:resource, :with_metadata, collection: collection) }
        let(:uuid) { resource.uuid }
        schema '$ref' => '#/definitions/metadata'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(resource.metadata['author'])
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
