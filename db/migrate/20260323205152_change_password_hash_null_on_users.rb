class ChangePasswordHashNullOnUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :password_hash, true
  end
end
