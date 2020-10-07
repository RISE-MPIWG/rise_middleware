require "rails_helper"

RSpec.describe OrganisationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/organisations").to route_to("organisations#index")
    end

    it "routes to #show" do
      expect(get: "/organisations/1").to route_to("organisations#show", id: "1")
    end
  end
end
