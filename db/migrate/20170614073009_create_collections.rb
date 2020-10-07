class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections do |t|
      t.integer :created_by_id, index: true
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :original_uuid
      t.string :resources_url
      t.belongs_to :organisation
      t.string :name
      t.string :slug, index: :true
      t.string :api_url
      t.string :resources_url
      t.jsonb :metadata, null: false, default: '{}'
      t.index :metadata, using: :gin
      t.boolean :archived, default: false, index: true
      t.integer :access_type, default: 0, index: true
      t.integer :api_mapping_module, default: 0, index: true
      t.datetime :remote_updated_at, default: nil
      t.timestamps
    end
  end
end
