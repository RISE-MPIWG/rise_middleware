module Admin
  module ResearchTools
    class OrganisationsController < ApplicationController
      before_action :set_research_tool, only: %i[set_access]
      before_action :set_organisation, only: %i[set_access]

      def set_access
        @organisation.set_access_right_for_research_tool(@research_tool, access_params[:access_right])
        respond_to do |format|
          format.js {}
        end
      end

      private

      def set_organisation
        @organisation = Organisation.find(params[:id])
      end

      def set_research_tool
        @research_tool = ResearchTool.find(params[:research_tool_id])
      end

      def access_params
        params.fetch(:organisation_access, {}).permit(:access_right)
      end
    end
  end
end
