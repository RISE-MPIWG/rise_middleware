class CreateOrganisationResearchTools < ActiveRecord::Migration[5.1]
  def change
    create_table :organisation_research_tools do |t|
      t.belongs_to :organisation
      t.belongs_to :research_tool
      t.integer :access_right
      t.timestamps
    end
  end
end
