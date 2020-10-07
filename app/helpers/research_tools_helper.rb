module ResearchToolsHelper
  def organisation_access_for_research_tool(organisation, research_tool)
    ort = OrganisationResearchTool.find_by(organisation_id: organisation.id, research_tool_id: research_tool.id)
    if ort.present?
      ort.access_right
    else
      OrganisationResearchTool::ACCESS_RIGHTS.first.first
    end
  end
end
