class CreateOrganisationResources < ActiveRecord::Migration[5.1]
  def change
    create_table :organisation_resources do |t|
      t.belongs_to :organisation
      t.belongs_to :resource
      t.integer :access_right
      t.jsonb :acl
      t.timestamps
    end
  end
end
