class CreateOrganisationCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :organisation_collections do |t|
      t.belongs_to :organisation, index: { name: 'index_orc_organisation' }
      t.belongs_to :collection, index: { name: 'index_orc_collection' }
      t.string :api_key, default: ''
      t.integer :access_right, default: 0, index: true
      t.timestamps
    end
  end
end
