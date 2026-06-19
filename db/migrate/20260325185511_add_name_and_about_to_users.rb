class AddNameAndAboutToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string unless column_exists?(:users, :name)
    add_column :users, :about, :text unless column_exists?(:users, :about)
  end
end
