require 'swagger_helper'

describe 'Corpora API' do
  path '/api/corpora/{uuid}/resources' do
    get 'Get the list of all corpora' do
      tags 'Corpora' # is it used for swagger
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Corpus you wish to access', required: true

      response '200', 'OK' do
        let(:current_user) { create(:user) }
        let(:corpus) { create(:corpus, created_by: current_user) }

        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { corpus.uuid }
        let!(:resource_1) { create(:resource) }
        let!(:corpus_resource_1) { create(:corpus_resource, corpus: corpus, resource: resource_1) }
        run_test! do |response|
          expect(JSON.parse(response.body).size).to eq(1)
        end
      end

      response '401', 'unauthorised access to the corpora' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:corpus).uuid }
        run_test!
      end

      response '404', 'Corpus not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end
    end
  end
end
