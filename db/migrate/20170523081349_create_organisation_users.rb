class CreateOrganisationUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :organisation_users do |t|
      t.belongs_to :organisation
      t.belongs_to :user
      t.integer :role
      t.timestamps
    end
  end
end
