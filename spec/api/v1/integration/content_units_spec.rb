require 'swagger_helper'

describe 'Content Units API' do
  path '/api/content_units/{uuid}' do
    get 'Retrieves a content unit' do
      tags 'Content Units'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Content Unit you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:resource) { create(:resource, collection: collection) }
        let!(:section) { create(:section, resource: resource) }
        let!(:content_unit) { create(:content_unit, section: section) }
        let(:uuid) { content_unit.uuid }
        schema '$ref' => '#/definitions/content_unit'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(content_unit.content)
        end
      end

      response '401', 'unauthorised access to this content_unit' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:content_unit).uuid }
        run_test!
      end

      response '404', 'content unit not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end
    end

    get 'Retrieves a content unit for an unauthenticated user' do
      tags 'Content Units'
      produces 'application/json'
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Content Unit you wish to access', required: true
      response '200', 'OK' do
        let!(:public_collection) { create(:collection, :with_public_access) }
        let!(:resource) { create(:resource, collection: public_collection) }
        let!(:section) { create(:section, resource: resource) }
        let!(:content_unit) { create(:content_unit, section: section) }
        let(:uuid) { content_unit.uuid }
        schema '$ref' => '#/definitions/content_unit'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(content_unit.content)
        end
      end

      response '401', 'unauthorised access to this content unit' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:content_unit).uuid }
        run_test!
      end

      response '404', 'content unit not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/content_units/{uuid}/metadata' do
    get 'Returns a json object containing a content unit\'s metadata' do
      tags 'Content Units'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Content Unit you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:resource) { create(:resource, collection: collection) }
        let!(:section) { create(:section, :with_metadata, resource: resource) }
        let!(:content_unit) { create(:content_unit, :with_metadata, section: section) }
        let(:uuid) { content_unit.uuid }
        schema '$ref' => '#/definitions/metadata'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(content_unit.metadata['author'])
        end
      end

      response '401', 'unauthorised access to this content unit' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:content_unit).uuid }
        run_test!
      end

      response '404', 'content unit not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end
    end
  end
end
