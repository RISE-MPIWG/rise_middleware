require 'rails_helper'

RSpec.describe CorporaController, type: :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      corpus = Corpus.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      corpus = Corpus.create! valid_attributes
      get :show, params: { id: collection.to_param }, session: valid_session
      expect(response).to be_success
    end
  end
end
