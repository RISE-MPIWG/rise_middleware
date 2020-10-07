module Api
  module V1
    class CorporaController < Api::ApiController
      before_action :require_login!
      before_action :set_corpus, only: %i{show}

      require_power_check
      power crud: :corpora, as: :corpus_scope

      def index
        @corpora = current_power.readable_corpora
        paginate json: @corpora
      end

      def show
        unless current_power.readable_corpus?(@corpus)
          render json: { error: 'you do not have access to this corpus' }, status: :unauthorized
          return
        end
        render json: @corpus
      end

      private

      def render_errors
        render json: { errors: @corpus.errors }, status: :unprocessable_entity
      end

      def set_corpus
        @corpus = Corpus.from_uuid(params[:uuid])
      end
    end
  end
end
