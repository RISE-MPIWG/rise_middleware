require 'rails_helper'

RSpec.describe Admin::CollectionsController, type: :controller do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      collection = Collection.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      collection = Collection.create! valid_attributes
      get :show, params: { id: collection.to_param }, session: valid_session
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
      collection = Collection.create! valid_attributes
      get :edit, params: { id: collection.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Collection" do
        expect {
          post :create, params: { collection: valid_attributes }, session: valid_session
        }.to change(Collection, :count).by(1)
      end

      it "redirects to the created collection" do
        post :create, params: { collection: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Collection.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { collection: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested collection" do
        collection = Collection.create! valid_attributes
        put :update, params: { id: collection.to_param, collection: new_attributes }, session: valid_session
        collection.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the collection" do
        collection = Collection.create! valid_attributes
        put :update, params: { id: collection.to_param, collection: valid_attributes }, session: valid_session
        expect(response).to redirect_to(collection)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        collection = Collection.create! valid_attributes
        put :update, params: { id: collection.to_param, collection: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested collection" do
      collection = Collection.create! valid_attributes
      expect {
        delete :destroy, params: { id: collection.to_param }, session: valid_session
      }.to change(Collection, :count).by(-1)
    end

    it "redirects to the collections list" do
      collection = Collection.create! valid_attributes
      delete :destroy, params: { id: collection.to_param }, session: valid_session
      expect(response).to redirect_to(collections_url)
    end
  end
end
