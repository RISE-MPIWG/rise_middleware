class CreateUserLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :user_logs do |t|
      t.references :loggable, polymorphic: true
      t.references :subject, polymorphic: true
      t.belongs_to :organisation
      t.string :controller
      t.string :action
      t.jsonb :raw_request
      t.string :request_origin
      t.string :request_method
      t.string :request_body
      t.jsonb :request_params
      t.timestamps
    end
  end
end
