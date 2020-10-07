# require 'swagger_helper'
# 
# describe 'Resources API' do
#   path '/api/search' do
#     get 'search a term in all collections that provide full text search' do
#       tags 'Full Text Search'
#       produces 'application/json'
#       security [apiToken: []]
#       parameter name: :page, in: :query, type: :integer, description: 'The page required', required: false
#       parameter name: :per_page, in: :query, type: :integer, description: 'The required number of results per page', required: false
#       parameter name: :q, in: :query, type: :string, description: 'a string to filter the returned resources by name', required: false
#       response '200', 'OK' do
#         let(:organisation) { create(:organisation) }
#         let(:current_user) { create(:user, organisation: organisation) }
#         let!(:collection) { create(:collection) }
#         let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
#         let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
#         let!(:resource) { create(:resource, collection: collection) }
#         let!(:section) { create(:section, resource: resource) }
#         let!(:content_unit) { create(:content_unit, section: section) }
#         schema type: :array,
#                items: { '$ref' => '#/definitions/search_results' }
#         after do |example|
#           example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
#         end
#         run_test! do |response|
#           expect(JSON.parse(response.body).size).to eq(5)
#         end
#       end
# 
#       response '200', 'OK' do
#         let!(:organisation) { create(:organisation) }
#         let(:current_user) { create(:user, organisation: organisation) }
#         let!(:collection) { create(:collection) }
#         let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
#         let!(:organisation_collection) { create(:organisation_collection, :read_access, organisation: organisation, collection: collection) }
#         let!(:resources_list) { create_list(:resource, 2, collection: collection) }
#         let!(:resource_matching_filter) { create(:resource, collection: collection, name: 'match_this_filter') }
#         let(:filter) { 'match_this_filter' }
#         schema type: :array,
#                items: { '$ref' => '#/definitions/resource_for_index' }
#         run_test! do |response|
#           expect(JSON.parse(response.body).size).to eq(1)
#           expect(response.body).to include(resource_matching_filter.name)
#         end
#       end
#     end
#   end
# end
