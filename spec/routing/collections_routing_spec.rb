require "rails_helper"

RSpec.describe CollectionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/collections").to route_to("collections#index")
    end

    it "routes to #show" do
      expect(get: "/collections/1").to route_to("collections#show", id: "1")
    end
  end
end
