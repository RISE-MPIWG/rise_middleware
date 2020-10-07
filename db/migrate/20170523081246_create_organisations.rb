class CreateOrganisations < ActiveRecord::Migration[5.1]
  def change
    create_table :organisations do |t|
      t.integer :created_by_id, index: true
      t.string :name
      t.string :slug
      t.string :api_url
      t.integer :api_mapping_module, default: 0, index: true
      t.string :saml_issuer_uri
      t.string :api_key
      t.integer :organisation_type, index: true
      t.boolean :archived, default: false, index: true
      t.integer :default_collection_access_type, default: 0, index: true
      t.jsonb   :default_collection_metadata, default: {}
      t.index :default_collection_metadata, using: :gin
      t.timestamps
    end
  end
end
