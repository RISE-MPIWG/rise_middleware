module Admin
  module Collections
    class ResearchToolsController < ApplicationController
      before_action :set_collection, only: %i[set_access]
      before_action :set_research_tool, only: %i[set_access]

      def set_access
        @research_tool.set_access_right_for_collection(@collection, access_params[:access_right])
        respond_to do |format|
          format.js {}
        end
      end

      private

      def set_research_tool
        @research_tool = ResearchTool.find(params[:id])
      end

      def set_collection
        @collection = Collection.find(params[:collection_id])
      end

      def access_params
        params.fetch(:research_tool_access, {}).permit(:access_right)
      end
    end
  end
end
