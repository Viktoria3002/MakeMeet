class AddModerationFieldsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :status, :string, null: false, default: "pending"
    add_column :posts, :moderation_comment, :text
    add_column :posts, :moderated_by, :bigint

    add_index :posts, :status
    add_foreign_key :posts, :users, column: :moderated_by
  end
end