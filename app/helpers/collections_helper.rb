module CollectionsHelper
  def organisation_access_for_collection(organisation, collection)
    oc = OrganisationCollection.find_by(organisation_id: organisation.id, collection_id: collection.id)
    if oc.present?
      oc.access_right
    else
      OrganisationCollection::ACCESS_RIGHTS.first.first
    end
  end

  def research_tool_access_for_collection(research_tool, collection)
    rtc = ResearchToolCollection.find_by(research_tool_id: research_tool.id, collection_id: collection.id)
    if rtc.present?
      rtc.access_right
    else
      ResearchToolCollection::ACCESS_RIGHTS.first.first
    end
  end
end
