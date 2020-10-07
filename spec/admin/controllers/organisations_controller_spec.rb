require 'rails_helper'

RSpec.describe Admin::OrganisationsController, type: :controller do
  login_admin
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      organisation = Organisation.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      organisation = Organisation.create! valid_attributes
      get :show, params: { id: organisation.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      organisation = Organisation.create! valid_attributes
      get :edit, params: { id: organisation.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Organisation" do
        expect {
          post :create, params: { organisation: valid_attributes }, session: valid_session
        }.to change(Organisation, :count).by(1)
      end

      it "redirects to the created organisation" do
        post :create, params: { organisation: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Organisation.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { organisation: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested organisation" do
        organisation = Organisation.create! valid_attributes
        put :update, params: { id: organisation.to_param, organisation: new_attributes }, session: valid_session
        organisation.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the organisation" do
        organisation = Organisation.create! valid_attributes
        put :update, params: { id: organisation.to_param, organisation: valid_attributes }, session: valid_session
        expect(response).to redirect_to(organisation)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        organisation = Organisation.create! valid_attributes
        put :update, params: { id: organisation.to_param, organisation: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested organisation" do
      organisation = Organisation.create! valid_attributes
      expect {
        delete :destroy, params: { id: organisation.to_param }, session: valid_session
      }.to change(Organisation, :count).by(-1)
    end

    it "redirects to the organisations list" do
      organisation = Organisation.create! valid_attributes
      delete :destroy, params: { id: organisation.to_param }, session: valid_session
      expect(response).to redirect_to(organisations_url)
    end
  end
end
