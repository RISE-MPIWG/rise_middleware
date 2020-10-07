module Api
  module V1
    class ToolExportsController < Api::ApiController
      before_action :require_login!
      before_action :set_tool_export, only: %i{show upload}

      require_power_check
      power crud: :tool_exports, as: :corpus_scope

      def index
        @corpora = current_power.readable_tool_exports
        paginate json: @corpora
      end

      def create
        research_tool = ResearchTool.where("url ILIKE '%#{request.referer}%'").first
        render json: { error: 'this research tool is unauthorized or doesn\'t exist' } if research_tool.nil?
        sections = Section.where(uuid: tool_export_params[:section_uuids])
        tool_export = ToolExport.new(
          name: tool_export_params[:name],
          notes: tool_export_params[:notes],
          resource_metadata: sections.to_json,
          research_tool: research_tool,
          user: current_user,
          file_data_uri: tool_export_params[:file_data_uri]
        )
        if tool_export.save
          tool_export.reload
          render json: { uuid: tool_export.uuid }
        else
          render json: { errors: tool_export.errors.to_json }, status: :unprocessable_entity
        end
      end

      def show
        unless current_power.readable_tool_export?(@tool_export)
          render json: { error: 'you do not have access to this tool export' }, status: :unauthorized
          return
        end
        render json: @tool_export
      end

      private

      def render_errors
        render json: { errors: @tool_export.errors }, status: :unprocessable_entity
      end

      def set_tool_export
        @tool_export = ToolExport.from_uuid(params[:uuid])
      end

      def tool_export_params
        params.permit(:file_data_uri, :name, :notes, section_uuids: [])
      end
    end
  end
end
