require 'swagger_helper'

describe 'Collections API' do
  path '/api/collections' do
    get 'Get the list of all collections the current user has access to' do
      tags 'Collections'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
      parameter name: :filter, in: :query, type: :string, description: 'a string to filter the returned collections by name', required: false
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:accessible_collection_1) { create(:collection) }
        let!(:accessible_collection_2) { create(:collection) }
        let!(:public_collection) { create(:collection, :with_public_access) }
        let!(:forbidden_collection_1)  { create(:collection) }
        let!(:forbidden_collection_2)  { create(:collection) }
        let!(:organisation_collection_1) { create(:organisation_collection, :read_access, collection: accessible_collection_1, organisation: organisation) }
        let!(:organisation_collection_2) { create(:organisation_collection, :read_access, collection: accessible_collection_2, organisation: organisation) }
        schema type: :array,
               items: { '$ref' => '#/definitions/collection' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(accessible_collection_1.name)
          expect(response.body).to include(accessible_collection_2.name)
          expect(response.body).to include(public_collection.name)
          expect(response.body).to_not include(forbidden_collection_1.name)
          expect(response.body).to_not include(forbidden_collection_2.name)
        end
      end

      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:collection_1) { create(:collection) }
        let!(:collection_matching_filter) { create(:collection, name: 'match_this_filter') }
        let!(:organisation_collection_1) { create(:organisation_collection, :read_access, collection: collection_1, organisation: organisation) }
        let!(:organisation_collection_matching_filter) { create(:organisation_collection, :read_access, collection: collection_matching_filter, organisation: organisation) }
        let(:filter) { 'match_this_filter' }
        schema type: :array,
               items: { '$ref' => '#/definitions/collection' }
        run_test! do |response|
          expect(response.body).to include(collection_matching_filter.name)
          expect(response.body).to_not include(collection_1.name)
        end
      end
    end

    get 'Get the list of all collections an unauthenticated user has access to' do
      tags 'Collections'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
      parameter name: :filter, in: :query, type: :string, description: 'a string to filter the returned collections by name', required: false
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let!(:public_collection) { create(:collection, :with_public_access) }
        schema type: :array,
               items: { '$ref' => '#/definitions/collection' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(public_collection.name)
        end
      end
    end
  end

  path '/api/collections/{uuid}' do
    get 'Retrieves a collection' do
      tags 'Collections'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Collection you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, collection: collection, organisation: organisation) }
        let(:uuid) { collection.uuid; }
        schema '$ref' => '#/definitions/collection'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(collection.name)
        end
      end

      response '404', 'resource not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end

      response '401', 'no access to this collection' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:collection).uuid }
        run_test!
      end
    end

    get 'Retrieves a collection' do
      tags 'Collections'
      produces 'application/json'
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Collection you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let!(:public_collection) { create(:collection, :with_public_access) }
        let(:uuid) { public_collection.uuid; }
        schema '$ref' => '#/definitions/collection'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(public_collection.name)
        end
      end

      response '404', 'resource not found' do
        let(:uuid) { 'invalid' }
        run_test!
      end

      response '401', 'no access to this collection' do
        let(:uuid) { create(:collection).uuid }
        run_test!
      end
    end
  end

  path '/api/collections/{uuid}/research_tools' do
    get 'Lists the research tools accessible to this collection' do
      tags 'Collections'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Collection', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:collection) { create(:collection) }
        let!(:research_tools_list) { create_list(:research_tool, 2) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, collection: collection, organisation: organisation) }
        let!(:organisation_research_tool_1) { create(:organisation_research_tool, :enabled, research_tool: research_tools_list[0], organisation: organisation) }
        let!(:organisation_research_tool_2) { create(:organisation_research_tool, :enabled, research_tool: research_tools_list[1], organisation: organisation) }
        let(:uuid) { collection.uuid; }
        schema type: :array,
               items: { '$ref' => '#/definitions/research_tool' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(research_tools_list[0].name)
          expect(response.body).to include(research_tools_list[1].name)
        end
      end

      response '404', 'resource not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end

      response '401', 'no access to this collection' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:collection).uuid }
        run_test!
      end
    end

    get 'Lists the research tools accessible to a collection' do
      tags 'Collections'
      produces 'application/json'
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Collection you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let!(:public_collection) { create(:collection, :with_public_access) }
        let!(:research_tools_list) { create_list(:research_tool, 2) }
        let(:uuid) { public_collection.uuid; }
        schema type: :array,
               items: { '$ref' => '#/definitions/research_tool' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(research_tools_list[0].name)
          expect(response.body).to include(research_tools_list[1].name)
        end
      end

      response '404', 'resource not found' do
        let(:uuid) { 'invalid' }
        run_test!
      end

      response '401', 'no access to this collection' do
        let(:uuid) { create(:collection).uuid }
        run_test!
      end
    end
  end
end
