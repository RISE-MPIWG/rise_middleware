module Powers
  module Corpora
    as_trait do
      power :corpora do
        @user.corpora
      end

      power :readable_corpora do
        Corpus.where(created_by_id: @user.id)
      end

      power :updatable_corpora do
        case role_sym
        when :admin
          @user.corpora
        when :super_admin
          Corpus.active
        else
          Corpus.none
        end
      end

      power :updatable_corpus?, :destroyable_corpus?, :readable_corpus? do |corpus|
        corpus.created_by_id == @user.id
      end

      power :creatable_corpora do
        Corpus.where(created_by_id: @user.id)
      end

      power :destroyable_corpora do
        Corpus.where(created_by_id: @user.id)
      end
    end
  end
end
