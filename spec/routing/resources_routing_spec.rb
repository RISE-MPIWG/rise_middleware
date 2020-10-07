require "rails_helper"

RSpec.describe ResourcesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/resources").to route_to("resources#index")
    end

    it "routes to #show" do
      expect(get: "/resources/1").to route_to("resources#show", id: "1")
    end
  end
end
