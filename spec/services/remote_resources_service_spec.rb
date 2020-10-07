require "rails_helper"
RSpec.describe RemoteResourcesService do
  context 'standard collection' do
    let(:collection) { create :collection, :with_index_and_cache, api_mapping_module: 'standard' }
    before(:each) do
      response =
        '[{"uuid":"00201","name":"resource"}]'
      stub_request(:get, "#{collection.api_url}/resources").
        with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10'
          }
        ).
        to_return(status: 200, body: response, headers: {})
      stub_request(:get, "#{collection.api_url}/resources/00201/metadata").
        with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type' => 'application/json',
            'User-Agent' => 'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10'
          }
        ).
        to_return(status: 200, body: '{"author": "pbelouin"}', headers: {})

      stub_request(:get, "#{collection.api_url}//resources?page=1&per_page=600000").
        with(
          headers: {
         'Content-Type'=>'application/json',
         'Expect'=>'',
         'User-Agent'=>'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10'
          }).
        to_return(status: 200, body: response, headers: {})

      stub_request(:get, "#{collection.api_url}/resources/00201/metadata").
        with(
          headers: {
         'Content-Type'=>'application/json',
         'Expect'=>'',
         'User-Agent'=>'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.10) Gecko/20100915 Ubuntu/10.04 (lucid) Firefox/3.6.10'
          }).
        to_return(status: 200, body: '{"author": "pbelouin"}', headers: {})
    end
    subject { RemoteResourcesService.new(collection.id) }
    it 'should delete index and cache' do
      res = collection.resources.first
      sect = res.sections.first
      cu = sect.content_units.first
      subject.refresh_resources
      expect(Resource.exists?(res.id)).to be_falsey
      expect(Section.exists?(sect.id)).to be_falsey
      expect(ContentUnit.exists?(cu.id)).to be_falsey
    end
    it 'should pull the new index' do
      subject.refresh_resources
      expect(collection.resources.count).to eq 1
      expect(collection.resources.first.metadata['author']).to eq 'pbelouin'
    end
  end
end
