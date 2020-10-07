# == Schema Information
#
# Table name: corpora
#
#  id            :bigint(8)        not null, primary key
#  created_by_id :integer
#  uuid          :uuid             not null
#  name          :string
#  description   :text
#  archived      :boolean          default(FALSE)
#  privacy_type  :integer          default("private_access")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Corpus, type: :model do
  let(:corpus) { create :corpus, name: 'My corpus' }

  it_behaves_like 'archivable'
  it_behaves_like 'uuid_findable'

  it { is_expected.to have_many(:corpus_resources).inverse_of(:corpus) }
  it { is_expected.to have_many(:resources) }
  it { is_expected.to belong_to(:created_by).class_name('User') }

  describe '#to_s' do
    it 'should return the name of the corpus' do
      expect(corpus.to_s).to eq "My corpus"
    end
  end

  describe '#addable_resources' do
    let!(:resources_list) { create_list :resource, 5 }
    let!(:resource_one) { create :resource }
    let!(:corpus_resource) { create :corpus_resource, corpus: corpus, resource: resource_one }

    it 'should return addable resources' do
      expect(corpus.addable_resources).not_to include resource_one
    end
  end
end
