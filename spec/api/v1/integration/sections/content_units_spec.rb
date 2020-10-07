require 'swagger_helper'

describe 'Section / ContentUnits API' do
  path '/api/sections/{uuid}/content_units' do
    get 'Get the list of all content units for a section' do
      tags 'Sections'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the section you wish to access', required: true
      parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
      parameter name: :filter, in: :query, type: :string, description: 'a string to filter the returned content units by title or contents', required: false
      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:resource) { create(:resource, collection: collection) }
        let!(:section) { create(:section, resource: resource) }
        let(:uuid) { section.uuid }
        let!(:content_units) { create_list(:content_unit, 6, section: section) }

        before do
          Section.any_instance.stub(:pull_content_units).and_return(content_units)
        end


        schema type: :array,
               items: { '$ref' => '#/definitions/content_unit' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(6)
        end
      end

      response '200', 'OK' do
        let(:organisation) { create(:organisation) }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:collection) { create(:collection) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
        let(:resource) { create(:resource, collection: collection) }
        let!(:section) { create(:section, resource: resource) }
        let(:uuid) { section.uuid }
        let!(:content_units) { create_list(:content_unit, 2, section: section) }
        let!(:content_unit_matching_filter) { create(:content_unit, section: section, name: 'match_this_filter', content: 'match_this_filter') }
        let(:filter) { 'match_this_filter' }

        before do
          Section.any_instance.stub(:pull_content_units).and_return(content_units + [content_unit_matching_filter])
        end

        schema type: :array,
               items: { '$ref' => '#/definitions/content_unit' }
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(1)
          expect(response.body).to include(content_unit_matching_filter.name)
        end
      end

      response '401', 'unauthorised access to this section' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:section).uuid }
        run_test!
      end

      response '404', 'section not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end
    end
  end
end
