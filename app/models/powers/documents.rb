module Powers
  module Documents
    as_trait do
      power :documents do
        PgSearch::Document.all.includes(:searchable)
      end
    end
  end
end
