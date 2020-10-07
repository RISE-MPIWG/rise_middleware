module Api
  module V1
    module Corpora
      class ResourcesController < Api::ApiController
        before_action :require_login!
        before_action :set_resource, only: %i{show}
        before_action :set_corpus, only: %i{index}

        require_power_check
        power crud: :resources, as: :resource_scope

        def index
          unless current_power.readable_corpus?(@corpus)
            render json: { error: 'you do not have access to this corpus' }, status: :unauthorized
            return
          end
          @resources = @corpus.resources
          paginate json: @resources
        end

        private

        def set_corpus
          @corpus = Corpus.from_uuid(params[:corpus_uuid])
        end
      end
    end
  end
end
