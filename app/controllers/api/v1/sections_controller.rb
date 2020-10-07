module Api
  module V1
    class SectionsController < Api::ApiController
      before_action :set_section, only: %i{show metadata}
      before_action :set_headers, only: :show

      require_power_check
      power crud: :sections, as: :section_scope

      def show
        unless current_power.readable_resource?(@section.resource)
          render json: { error: 'you do not have access to the collection this resource belongs to' }, status: :unauthorized
          return
        end
        begin
          @content_units = @section.pull_content_units(current_user)
        rescue StandardError => e  
          error = { error: [e] }
        end
        respond_to do |format|
          if error
            format.all {render json: error }
            return
          end          
          format.html { render json: @section, content_unit_count: @content_units.size }
          format.json { render json: @section, content_unit_count: @content_units.size  }
          if request.headers["Content-Type"] == 'application/tei+xml' && @section.resource.collection.api_mapping_module.to_sym == :dts
            xml = open(@section.uri)
            format.xml { render xml: xml }
          else
            format.xml  { render xml: SectionRenderer.xml(@section) }
          end
        end
      end

      def metadata
        unless current_power.readable_resource?(@section.resource)
          render json: { error: 'you do not have access to the resource this section belongs to' }, status: :unauthorized
          return
        end
        render json: @section.cascading_metadata.to_json
      end

      private
      
      def set_headers
        response.headers['Accept'] = ['application/json', 'application/xml']
      end

      def render_errors
        render json: { errors: @section.errors }, status: :unprocessable_entity
      end

      def set_section
        @section = Section.from_uuid(params[:uuid])
      end
    end
  end
end
