class CreateCorpora < ActiveRecord::Migration[5.1]
  def change
    create_table :corpora do |t|
      t.integer :created_by_id, index: true
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :name
      t.text :description
      t.boolean :archived, default: false, index: true
      t.integer :privacy_type, default: 0, index: true
      t.timestamps
    end
  end
end
