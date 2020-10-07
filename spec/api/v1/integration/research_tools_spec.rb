require 'swagger_helper'

describe 'ResearchTools API' do
  path '/api/research_tools' do
    get 'Get the list of all research tools the current user has access to' do
      tags 'ResearchTools'
      produces 'application/json'
      security [apiToken: []]
      response '200', 'OK' do
        let(:organisation) { create :organisation }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:research_tool_1) { create :research_tool }
        let!(:research_tool_2) { create :research_tool }
        let!(:organisation_research_tool_1) { create(:organisation_research_tool, :enabled, research_tool: research_tool_1, organisation: organisation) }
        let!(:organisation_research_tool_2) { create(:organisation_research_tool, :enabled, research_tool: research_tool_2, organisation: organisation) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { research_tool.uuid }
        schema type: :array,
               items: { '$ref' => '#/definitions/research_tool' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include research_tool_1.name
          expect(response.body).to include research_tool_2.name
        end
      end
    end
  end

  path '/api/research_tools/{uuid}' do
    get 'Retrieves a research_tool' do
      tags 'ResearchTools'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Research Tool you wish to access', required: true
      response '200', 'OK' do
        let(:organisation) { create :organisation }
        let(:current_user) { create(:user, organisation: organisation) }
        let!(:research_tool) { create :research_tool }
        let!(:organisation_research_tool) { create(:organisation_research_tool, :enabled, research_tool: research_tool, organisation: organisation) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { research_tool.uuid }
        schema '$ref' => '#/definitions/research_tool'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include research_tool.name
        end
      end

      response '404', 'research tool not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end

      # TODO all users have access to the research tool endpoint at the moment...
      # response '401', 'no access to this research_tool' do
      #   let(:current_user) { create(:user) }
      #   let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
      #   let(:uuid) { create(:tool_export).uuid }
      #   run_test!
      # end
    end
  end

  path '/api/research_tools/{uuid}/sections_import_url' do
    post 'Generates a research tool import url for the sections uuids provided as parameters. Original (resource provider) uuids conforming to the AN standard can also be provided' do
      tags 'ResearchTools'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Research Tool you wish to use', required: true
      parameter name: :body, in: :body, schema: { '$ref' => '#/definitions/research_tool_url_generation_params' }, description: 'The data required to generate a valid research tool url to fetch an array of sections from Rise', required: true
      response '200', 'OK' do
        let!(:research_tool) { create :research_tool }
        let!(:an_sections) { create_list(:section, 4) }
        let!(:remote_resource) { create(:resource) }
        let!(:remote_sections) { create_list(:section, 4, resource: remote_resource) }
        let(:uuid) { research_tool.uuid }
        let(:body) {
          {
            section_uuids: an_sections.map(&:uuid),
            original_resource_uuid: remote_resource.original_uuid,
            original_section_uuids: remote_sections.map(&:original_uuid)
          }
        }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include research_tool.url
          expect(response.body).to include root_url
          expect(response.body).to include an_sections.first.uuid
          expect(response.body).to include remote_sections.last.uuid
        end
      end

      response '404', 'research tool not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end

      # TODO all users have access to the research tool endpoint at the moment...
      # response '401', 'no access to this research_tool' do
      #   let(:current_user) { create(:user) }
      #   let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
      #   let(:uuid) { create(:tool_export).uuid }
      #   run_test!
      # end
    end
  end
end
