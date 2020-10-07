# == Schema Information
#
# Table name: resources
#
#  id                :bigint(8)        not null, primary key
#  created_by_id     :integer
#  uuid              :uuid             not null
#  original_uuid     :string           default("")
#  remote_updated_at :datetime
#  collection_id     :bigint(8)
#  name              :string
#  uri               :string
#  contents          :jsonb
#  metadata          :jsonb
#  archived          :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Resource, type: :model do
  let(:user) { create :user }
  let(:collection) { create :collection, api_mapping_module: 'standard' }
  subject { create :resource, name: 'My resource', collection: collection, uri: 'https://localgazetteers-test.mpiwg-berlin.mpg.de/4rise/resources/00201' }

  let(:response_body) {
    [
      { "id": "5192805", "parentId": "5263264", "name": "序", "startPage": 1, "endPage": 10 },
      { "id": "5192806", "parentId": "5263264", "name": "甕安縣志纂輯銜名", "startPage": 11, "endPage": 14 },
      { "id": "1", "parentId": "5263264", "name": "甕安縣志目次", "startPage": 15, "endPage": 21 }
    ]
  }

  it_behaves_like "archivable"
  it_behaves_like "uuid_findable"


  it { is_expected.to belong_to(:collection).inverse_of(:resources) }
  it { is_expected.to belong_to(:created_by).class_name('User') }
  it { is_expected.to have_one(:organisation).inverse_of(:resources) }

  it { is_expected.to have_many(:sections).inverse_of(:resource) }
  it { is_expected.to have_many(:content_units).through(:sections) }

  it { is_expected.to have_many(:corpus_resources).inverse_of(:resource) }
  it { is_expected.to have_many(:corpora).through(:corpus_resources) }

  describe '#to_s' do
    it 'should return the name of the resource' do
      expect(subject.to_s).to eq "My resource"
    end
  end

  describe '#pull_full_text' do
    before { stub_request(:get, "#{subject.uri}/sections").to_return(status: 200, body: response_body.to_json ) }
    it 'should call manage standard collection module and build section for the resource' do
      # subject.pull_full_text(user)
      # expect(subject.sections.count).to eq(3)
      skip
    end
  end

  describe "#pull_sections" do
    before { stub_request(:get, "#{subject.uri}/sections").to_return(status: 200, body: response_body.to_json ) }
    it 'should call manage standard collection module and build section for the resource' do
      # subject.pull_sections(user)
      # expect(subject.sections.count).to eq(3)
      skip
    end
  end
end
