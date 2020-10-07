# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  xasia_token            :string           default(""), not null
#  preferred_language     :integer
#  role                   :integer          default("standard_user")
#  archived               :boolean          default(FALSE)
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  organisation_id        :bigint(8)
#  affiliation            :string
#  name                   :string
#  position               :string
#  auth_token             :string
#  token_created_at       :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  uid                    :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to have_many(:user_logs) }
    it { is_expected.to have_many(:corpora) }
  end

  describe "Token" do
    let(:user) { create :user }
    let(:user_with_token) { create :user, :with_token }

    it "should create token after user is created" do
      user.save
      expect(user.auth_token).not_to be nil
      expect(user.token_created_at).not_to be nil
    end

    it "should invalidate auth token" do
      user_with_token.invalidate_auth_token
      expect(user_with_token.auth_token).to be nil
      expect(user_with_token.token_created_at).to be nil
    end
  end

  describe "Access right" do
    let(:organisation) { create :organisation }
    let(:collection_1) { create :collection, organisation: organisation }
    let(:user) { create :user, organisation: organisation }

    let(:organisation_2) { create :organisation }
    let(:collection_with_access) { create :collection, organisation: organisation_2 }
    let(:organisation_collection) { create :organisation_collection, access_right: 'read', collection: collection_with_access, organisation: organisation }
    let(:resource) { create :resource, collection: collection_with_access }
    let(:collection_without_access) { create :collection }

    it "should return owner for collection" do
      expect(user.access_right_for_model(collection_1)).to eq(:owner)
    end

    it "should return access right :read for resource" do
      organisation_collection
      expect(user.access_right_for_model(resource)).to eq(:read)
    end

    it "should return :no_access for collection" do
      expect(user.access_right_for_model(collection_without_access)).to eq(:no_access)
    end
  end

  describe "#to_s" do
    let(:user) { create :user, email: 'example@email.com' }

    it 'should return an email of user' do
      expect(user.to_s).to eq 'example@email.com'
    end
  end

  describe "#colleagues" do
    let(:organisation) { create :organisation }
    let(:user) { create :user, organisation: organisation }
    let!(:colleagues) { create_list :user, 3, organisation: organisation }

    it 'should return all users of this organisation' do
      expect(user.colleagues.count).to eq(4)
    end
  end
end
