class CreateResources < ActiveRecord::Migration[5.1]
  def change
    create_table :resources do |t|
      t.integer :created_by_id, index: true
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :original_uuid, default: ''
      t.timestamp :remote_updated_at, default: nil
      t.belongs_to :collection
      t.belongs_to :organisation
      t.string :name
      t.string :uri
      t.jsonb :contents
      t.jsonb :metadata
      t.index :metadata, using: :gin
      t.boolean :archived, default: false, index: true
      t.timestamps
    end
  end
end
