require 'rails_helper'

RSpec.describe ResearchToolsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # ResearchTool. As you add validations to ResearchTool, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ResearchToolsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      research_tool = ResearchTool.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      research_tool = ResearchTool.create! valid_attributes
      get :show, params: { id: research_tool.to_param }, session: valid_session
      expect(response).to be_success
    end
  end
end
