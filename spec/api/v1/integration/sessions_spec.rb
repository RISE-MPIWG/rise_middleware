require 'swagger_helper'

describe 'Sessions API' do
  path '/api/sign_in' do
    post 'Sign In' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, description: 'The credentials of the user', schema: { '$ref' => '#/definitions/user_credentials' }, required: true
      response '200', 'User successfully logged in' do
        let(:user) { create(:user, password: 'password') }
        let(:credentials) { { user: { email: user.email, password: 'password' } } }
        schema '$ref' => '#/definitions/sign_in_response'
        before do |example|
          submit_request(example.metadata)
        end

        it 'returns a valid token in the authorization header' do |example|
          assert_response_matches_metadata(example.metadata)
          expect(json[:auth_token]).to be_instance_of(String)
        end
      end
      response '401', 'Unauthorized access - wrong credentials' do
        let(:credentials) { { user: { email: 'a@random.email', password: 'random_password' } } }
        run_test!
      end
    end
  end

  path '/api/sign_out' do
    delete 'Sign Out' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      security [apiToken: []]
      response '200', 'User successfully logged out' do
        let(:current_user) { create(:user) }
        let(:'RISE-API-TOKEN') { get_auth_token_for(current_user) }
        run_test! do |_response|
          current_user.reload
          expect(current_user.auth_token).to be_nil
        end
      end
      response '401', 'Unauthorized access - wrong credentials' do
        let(:'RISE-API-TOKEN') { 'thisisnotacorrecttoken' }
        run_test!
      end
    end
  end
end
