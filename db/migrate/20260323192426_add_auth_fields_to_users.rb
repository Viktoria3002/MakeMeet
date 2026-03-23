class AddAuthFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :session_token, :string
    add_column :users, :role, :string, null: false, default: "author"

    add_index :users, :session_token, unique: true
    add_index :users, :role
  end
end
