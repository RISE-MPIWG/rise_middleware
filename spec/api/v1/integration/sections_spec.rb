require 'swagger_helper'

describe 'Sections API' do
  path '/api/sections/{uuid}' do
    get 'Retrieves a section' do
      tags 'Sections'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Section you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:resource) { create(:resource, collection: collection) }
        let!(:section) { create(:section, resource: resource) }
        let(:uuid) { section.uuid }
        let!(:content_units) { create_list(:content_unit, 2, section: section) }
        schema '$ref' => '#/definitions/section'
        before do
          Section.any_instance.stub(:pull_content_units).and_return(content_units)
        end

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(section.name)
        end
      end

      response '401', 'unauthorised access to this section' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:section).uuid }
        run_test!
      end

      response '404', 'resource not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end
    end

    get 'Retrieves a section for an unauthenticated user' do
      tags 'Sections'
      produces 'application/json'
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Section you wish to access', required: true
      response '200', 'OK' do
        let!(:public_collection) { create(:collection, :with_public_access) }
        let!(:resource) { create(:resource, collection: public_collection) }
        let!(:section) { create(:section, resource: resource) }
        let!(:content_units) { create_list(:content_unit, 2, section: section) }
        let(:uuid) { section.uuid }
        before do
          Section.any_instance.stub(:pull_content_units).and_return(content_units)
        end
        schema '$ref' => '#/definitions/section'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(section.name)
        end
      end

      response '401', 'unauthorised access to this section' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:section).uuid }
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

  path '/api/sections/{uuid}/metadata' do
    get 'Returns a json object containing a section\'s metadata' do
      tags 'Sections'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Section you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:resource) { create(:resource, collection: collection) }
        let!(:section) { create(:section, :with_metadata, resource: resource) }
        let(:uuid) { section.uuid }
        schema '$ref' => '#/definitions/metadata'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(section.metadata['author'])
        end
      end

      response '401', 'unauthorised access to this section' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:section).uuid }
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
