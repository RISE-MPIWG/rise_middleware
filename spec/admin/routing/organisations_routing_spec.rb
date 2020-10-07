require "rails_helper"

RSpec.describe OrganisationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/organisations").to route_to("admin/organisations#index")
    end

    it "routes to #new" do
      expect(get: "/admin/organisations/new").to route_to("admin/organisations#new")
    end

    it "routes to #show" do
      expect(get: "/admin/organisations/1").to route_to("admin/organisations#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/organisations/1/edit").to route_to("admin/organisations#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/admin/organisations").to route_to("admin/organisations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/organisations/1").to route_to("admin/organisations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/organisations/1").to route_to("admin/organisations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/organisations/1").to route_to("admin/organisations#destroy", id: "1")
    end
  end
end
