require 'swagger_helper'

describe 'Corpora API' do
  path '/api/corpora' do
    get 'Get the list of all corpora the current user has access to' do
      tags 'Corpora'
      produces 'application/json'
      security [apiToken: []]
      response '200', 'OK' do
        let(:current_user) { create(:user) }
        let!(:corpus_1) { create(:corpus, created_by: current_user) }
        let!(:corpus_2) { create(:corpus, created_by: current_user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { corpus.uuid }
        schema type: :array,
               items: { '$ref' => '#/definitions/corpus' }
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(corpus_1.name)
          expect(response.body).to include(corpus_2.name)
        end
      end
    end
  end

  path '/api/corpora/{uuid}' do
    get 'Retrieves a corpus' do
      tags 'Corpora'
      produces 'application/json'
      security [apiToken: []]
      parameter name: :uuid, in: :path, type: :string, description: 'The UUID of the Corpus you wish to access', required: true
      response '200', 'OK' do
        let(:current_user) { create(:user) }
        let!(:corpus) { create :corpus, created_by: current_user }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { corpus.uuid; }
        schema '$ref' => '#/definitions/corpus'
        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test! do |response|
          expect(response.body).to include(corpus.name)
        end
      end

      response '404', 'resource not found' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { 'invalid' }
        run_test!
      end

      response '401', 'no access to this corpus' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        let(:uuid) { create(:corpus).uuid }
        run_test!
      end
    end
  end
end
