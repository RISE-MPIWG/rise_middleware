require "rails_helper"

RSpec.describe ResourcesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/resources").to route_to("admin/resources#index")
    end

    it "routes to #new" do
      expect(get: "/admin/resources/new").to route_to("admin/resources#new")
    end

    it "routes to #show" do
      expect(get: "/admin/resources/1").to route_to("admin/resources#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/resources/1/edit").to route_to("admin/resources#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/admin/resources").to route_to("admin/resources#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/resources/1").to route_to("admin/resources#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/resources/1").to route_to("admin/resources#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/resources/1").to route_to("admin/resources#destroy", id: "1")
    end
  end
end
