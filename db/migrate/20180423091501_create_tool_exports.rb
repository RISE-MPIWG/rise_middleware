class CreateToolExports < ActiveRecord::Migration[5.1]
  def change
    create_table :tool_exports do |t|
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :name
      t.text :notes
      t.belongs_to :user
      t.jsonb :resource_metadata, null: false, default: '{}'
      t.index :resource_metadata, using: :gin
      t.belongs_to :research_tool
      t.string :file_data
      t.integer :privacy_type, default: 0, index: true
      t.boolean :archived, default: false, index: true
      t.timestamps
    end
  end
end
