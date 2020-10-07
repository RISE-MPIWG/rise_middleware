require "rails_helper"

RSpec.describe CorporaController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/corpora").to route_to("corpora#index")
    end

    it "routes to #new" do
      expect(get: "/corpora/new").to route_to("corpora#new")
    end

    it "routes to #show" do
      expect(get: "/corpora/1").to route_to("corpora#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/corpora/1/edit").to route_to("corpora#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/corpora").to route_to("corpora#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/corpora/1").to route_to("corpora#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/corpora/1").to route_to("corpora#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/corpora/1").to route_to("corpora#destroy", id: "1")
    end
  end
end
