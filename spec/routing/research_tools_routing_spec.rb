require "rails_helper"

RSpec.describe ResearchToolsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/research_tools").to route_to("research_tools#index")
    end

    it "routes to #new" do
      expect(get: "/research_tools/new").to route_to("research_tools#new")
    end

    it "routes to #show" do
      expect(get: "/research_tools/1").to route_to("research_tools#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/research_tools/1/edit").to route_to("research_tools#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/research_tools").to route_to("research_tools#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/research_tools/1").to route_to("research_tools#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/research_tools/1").to route_to("research_tools#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/research_tools/1").to route_to("research_tools#destroy", id: "1")
    end
  end
end
