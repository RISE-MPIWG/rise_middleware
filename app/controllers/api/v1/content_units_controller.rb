module Api
  module V1
    class ContentUnitsController < Api::ApiController
      before_action :set_content_unit, only: %i{show metadata}

      before_action :set_headers, only: :show

      require_power_check
      power crud: :content_units, as: :content_unit_scope

      def show
        unless current_power.readable_resource?(@content_unit.section.resource)
          render json: { error: 'you do not have access to the collection this content unit belongs to' }, status: :unauthorized
          return
        end
        respond_to do |format|
          format.html { render json: @content_unit }
          format.json { render json: @content_unit }
          format.xml  { render xml: ContentUnitRenderer.xml(@content_unit) }
        end
      end

      def metadata
        unless current_power.readable_resource?(@content_unit.section.resource)
          render json: { error: 'you do not have access to the resource this content unit belongs to' }, status: :unauthorized
          return
        end
        render json: @content_unit.cascading_metadata.to_json
      end

      private

      def set_headers
        response.headers['Accept'] = ['application/json', 'application/xml']
      end


      def render_errors
        render json: { errors: @content_unit.errors }, status: :unprocessable_entity
      end

      def set_content_unit
        @content_unit = ContentUnit.from_uuid(params[:uuid])
      end
    end
  end
end
