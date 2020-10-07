require 'swagger_helper'

describe 'RP Registration API' do
  path '/api/rp_services/register_instance' do
    post 'called by rps to get registered by this middleware instance' do
      tags 'Register RP'
      parameter name: 'HTTP_REFERER', in: :header, schema: { type: :string }, description: 'The referer header, used to identify the tool from which this call originates from'
      parameter name: :body, in: :body, schema: { '$ref' => '#/definitions/metadata_from_rp_instance' }, description: 'The data sent by the RP to the middleware instance', required: true
      consumes 'application/json'
      produces 'application/json'

      response '200', 'OK' do
        before {
          stub_request(:get, "http://docker.for.mac.host.internal:4000/api//collections?page=1&per_page=600000").
            with(
              headers: {
              'Content-Type'=>'application/json',
              'Expect'=>'',
              'User-Agent'=>'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10'
              }).
            to_return(status: 200, body: '[{"uuid":"d67898ee-0678-482c-8f43-c2759751cbad","name":"A Multilingual Data Set of Novels"}]', headers: {})

          stub_request(:get, "http://docker.for.mac.host.internal:4000/api/collections/d67898ee-0678-482c-8f43-c2759751cbad/metadata").
            with(
              headers: {
              'Content-Type'=>'application/json',
              'Expect'=>'',
              'User-Agent'=>'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10'
              }).
            to_return(status: 200, body: '[{"content_unit_type": "line"}]', headers: {})


        }

        let!(:organisation) {create(:organisation)}
        let!(:user) { create(:user, organisation: organisation) }
        let(:HTTP_REFERER) { 'https://rise-rp.mpiwg-berlin.mpg.de' }
        let(:body) {
          {
            email: user.email,
            organisation: user.organisation.name
          }
        }
        schema type: :object, schema: { uuid: :string }
        # after do |example|
        #   example.metadata[:response][:examples] = { 'application/json' => JSON.parse(body, symbolize_names: true) }
        # end
        run_test! do |response|
          expect(response.body).to include('registration_completed')
        end
      end
    end
  end
end
