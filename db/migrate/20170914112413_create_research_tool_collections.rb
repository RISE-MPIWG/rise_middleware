class CreateResearchToolCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :research_tool_collections do |t|
      t.belongs_to :research_tool, index: { name: 'index_orrt_research_tool' }
      t.belongs_to :collection, index: { name: 'index_orrt_collection' }
      t.integer :access_right
      t.timestamps
    end
  end
end
