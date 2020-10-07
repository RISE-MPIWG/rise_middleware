module Api
  module V1
    class ResearchToolsController < Api::ApiController
      before_action :require_login!, only: %i{index show}
      before_action :set_research_tool, only: %i{show sections_import_url}

      require_power_check
      power crud: :research_tools, as: :research_tool_scope

      def index
        @research_tools = current_power.readable_research_tools
        paginate json: @research_tools
      end

      def show
        unless current_power.readable_research_tool?(@research_tool)
          render json: { error: 'you do not have access to this research tool' }, status: :unauthorized
          return
        end
        render json: @research_tool
      end

      def sections_import_url
        resource = Resource.where(original_uuid: params[:original_resource_uuid]).first
        if resource && resource.sections.empty?
          # TODO we grab the first user so as to pull the section' resources, but this needs to be refactored with the proper user...
          # or we get rid of user when pulling sections...
          resource.pull_sections(User.first)
        end
        original_section_an_uuids = Section.where(original_uuid: params[:original_section_uuids]).pluck(:uuid)
        section_uuids = (params[:section_uuids] + original_section_an_uuids).uniq
        render json: { url: "#{@research_tool.url}?instance_url=#{root_url}&section_uuids=#{section_uuids.join(',')}" }
      end

      private

      def render_errors
        render json: { errors: @research_tool.errors }, status: :unprocessable_entity
      end

      def set_research_tool
        @research_tool = ResearchTool.from_uuid(params[:uuid])
      end

      def research_tool_params
        params.fetch(:research_tool, {})
      end
    end
  end
end
