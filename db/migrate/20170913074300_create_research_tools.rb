class CreateResearchTools < ActiveRecord::Migration[5.1]
  def change
    create_table :research_tools do |t|
      t.integer :created_by_id, index: true
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :name
      t.text :description
      t.string :url
      t.string :slug, index: :true
      t.boolean :archived, default: false, index: true
      t.timestamps
    end
  end
end
