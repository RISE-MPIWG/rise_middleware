class CreateUserResources < ActiveRecord::Migration[5.1]
  def change
    create_table :user_resources do |t|
      t.belongs_to :user
      t.belongs_to :resource
      t.integer :access_right
      t.timestamps
    end
  end
end
