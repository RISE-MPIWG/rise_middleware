# == Schema Information
#
# Table name: collections
#
#  id                 :bigint(8)        not null, primary key
#  created_by_id      :integer
#  uuid               :uuid             not null
#  original_uuid      :string
#  resources_url      :string
#  organisation_id    :bigint(8)
#  name               :string
#  slug               :string
#  api_url            :string
#  metadata           :jsonb            not null
#  archived           :boolean          default(FALSE)
#  access_type        :integer          default("private_access")
#  api_mapping_module :integer          default("no_mapping_module")
#  remote_updated_at  :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Collection, type: :model do
  it_behaves_like "archivable"
  it_behaves_like "uuid_findable"

  describe "Associations" do
    it { is_expected.to have_many(:resources) }
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to have_many(:organisation_collections) }
    it { is_expected.to have_many(:research_tool_collections) }
    it { is_expected.to belong_to(:created_by) }
  end

  describe "#mapping_module_set?" do
    let(:ctext_collection) { create :collection, api_mapping_module: 'ctext' }

    it "checks if mapping module is set" do
      expect(ctext_collection.mapping_module_set?).to be true
    end
  end

  describe "#resource_count" do
    let(:collection) { create :collection }
    let!(:resources_list) { create_list :resource, 5, collection: collection }

    it "should return the count of resources in collection" do
      expect(collection.resource_count).to eq(5)
    end
  end

  describe "#from_slug" do
    let!(:collection) { create :collection, slug: 'slug_no_1' }

    it "should find the collection by slug" do
      expect(described_class.from_slug('slug_no_1')).to eq collection
    end
  end
end
