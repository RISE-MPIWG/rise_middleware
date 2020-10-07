# == Schema Information
#
# Table name: organisations
#
#  id                             :bigint(8)        not null, primary key
#  created_by_id                  :integer
#  name                           :string
#  slug                           :string
#  api_url                        :string
#  api_mapping_module             :integer          default("no_mapping_module")
#  saml_issuer_uri                :string
#  api_key                        :string
#  organisation_type              :integer
#  archived                       :boolean          default(FALSE)
#  default_collection_access_type :integer          default("private_access")
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

require 'rails_helper'

RSpec.describe Organisation, type: :model do
  describe "Associations" do
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:resources) }
    it { is_expected.to have_many(:collections) }
    it { is_expected.to have_many(:organisation_collections) }

    it { is_expected.to have_many(:organisation_research_tools) }
    it { is_expected.to have_many(:research_tools) }

    it { is_expected.to validate_uniqueness_of(:slug) }
  end

  describe "Scopes" do
    let(:organisations_list) { create_list :organisation, 3 }
    let(:organisation) { create :organisation }

    it "should skip the organisation" do
      expect(described_class.all.skip_organisation(organisation)).not_to include organisation
    end

    it "should return organisations with certain organisation types" do
      described_class.all.resource_consumers.each do |org|
        expect %i[research_institute university].include(org.type)
      end
    end
  end

  describe "to_s" do
    let(:organisation) { create :organisation, name: 'Max Plank Institute' }
    let(:organisation_without_name) { create :organisation, name: nil, slug: 'org_slug_1' }

    it "should return a name of organisation" do
      expect(organisation.to_s).to eq 'Max Plank Institute'
    end

    it "should return a slug of organisation if no name" do
      expect(organisation_without_name.to_s).to eq 'org_slug_1'
    end

    it "should return a saml_issuer_uri of organisation if no name and no slug" do
      # should figure out what saml_issuer_uri is used for
    end
  end

  describe "Methods" do
    let(:organisation_one) { create :organisation }
    let(:organisation_collections) { create_list :organisation_collection, 3, access_right: 'read', organisation: organisation_one }
    let(:collection) { create :collection, organisation: organisation_one }
    let(:organisation_collection) { create :organisation_collection, access_right: 'read', organisation: organisation_one, collection: collection }
    let(:resources) { create_list :resource, 5, collection: collection, organisation: organisation_one }
    let(:research_tool) { create :research_tool }
    let(:organisation_research_tools) { create_list :organisation_research_tool, 3, :enabled, organisation: organisation_one }

    describe "collections_for_access_right" do
      it "should return collections with certain access right" do
        organisation_collections
        expect(organisation_one.collections_for_access_right('read').count).to eq(3)
      end
    end

    describe "resources_for_access_right" do
      it "should return resources with certain access right" do
        organisation_collection
        resources
        expect(organisation_one.resources_for_access_right('read').count).to eq(5)
      end
    end

    describe "set_access_right_for_collection" do
      it "should set access right for collection" do
        organisation_one.set_access_right_for_collection(collection, 'read')
        expect(organisation_one.organisation_collections.first.access_right).to eq('read')
      end
    end

    describe "set_access_right_for_research_tool" do
      it "should set access right for research tool" do
        organisation_one.set_access_right_for_research_tool(research_tool, 'enabled')
        expect(organisation_one.organisation_research_tools.first.access_right).to eq('enabled')
      end
    end

    describe "accessible_research_tools" do
      it "should return acceseble research tools for organisation" do
        organisation_research_tools
        expect(organisation_one.accessible_research_tools.count).to eq(3)
      end
    end
  end
end
