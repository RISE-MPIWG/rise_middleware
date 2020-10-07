module Api
  module V1
    module Collections
      class ResearchToolsController < Api::ApiController
        before_action :set_collection, only: %i{index}

        require_power_check
        power crud: :research_tools, as: :research_tool_scope

        def index
          unless current_power.readable_collection?(@collection)
            render json: { error: 'you do not have access to this collection' }, status: :unauthorized
            return
          end
          # TODO at the moment we return all research tools. In the future, we will allow collection owners to decide if they want to grant access to certain research tools
          @research_tools = current_power.readable_research_tools
          paginate json: @research_tools
        end

        def generate_research_tool_url; end

        private

        def set_collection
          @collection = Collection.from_uuid(params[:collection_uuid])
        end

        def set_research_tool; end
      end
    end
  end
end
