class CreateCorpusResources < ActiveRecord::Migration[5.1]
  def change
    create_table :corpus_resources do |t|
      t.belongs_to :corpus
      t.belongs_to :resource
      t.timestamps
    end
  end
end
