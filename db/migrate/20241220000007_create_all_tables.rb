class CreateAllTables < ActiveRecord::Migration[8.0]
  def change
    # Создаем таблицу users
    create_table :users do |t|
      t.integer :user_id
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_hash, null: false
      t.datetime :registration_date
      t.timestamps
    end

    add_index :users, :user_id, unique: true
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true

    # Создаем таблицу posts
    create_table :posts do |t|
      t.integer :post_id, null: false
      t.bigint :author_id, null: false
      t.text :content, null: false
      t.timestamps
    end

    add_index :posts, :post_id, unique: true
    add_index :posts, :created_at

    # Создаем таблицу comments
    create_table :comments do |t|
      t.integer :comment_id, null: false
      t.bigint :post_id, null: false
      t.bigint :author_id, null: false
      t.text :content, null: false
      t.bigint :parent_comment_id
      t.timestamps
    end

    add_index :comments, :comment_id, unique: true
    add_index :comments, :created_at

    # Создаем таблицу likes
    create_table :likes do |t|
      t.integer :like_id, null: false
      t.bigint :user_id, null: false
      t.string :target_type, null: false
      t.integer :target_id, null: false
      t.timestamps
    end

    add_index :likes, :like_id, unique: true
    add_index :likes, [ :user_id, :target_type, :target_id ], unique: true
    add_index :likes, [ :target_type, :target_id ]
    add_index :likes, :created_at

    # Создаем таблицу sprints
    create_table :sprints do |t|
      t.integer :sprint_id, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.timestamps
    end

    add_index :sprints, :sprint_id, unique: true
    add_index :sprints, :start_date
    add_index :sprints, :end_date

    # Создаем таблицу sprint_participants
    create_table :sprint_participants do |t|
      t.integer :sprint_participant_id, null: false
      t.bigint :sprint_id, null: false
      t.bigint :user_id, null: false
      t.datetime :join_date
      t.string :progress_status, default: 'not_started'
      t.timestamps
    end

    add_index :sprint_participants, :sprint_participant_id, unique: true
    add_index :sprint_participants, [ :sprint_id, :user_id ], unique: true
    add_index :sprint_participants, :progress_status
    add_index :sprint_participants, :join_date

    # Добавляем внешние ключи
    add_foreign_key :posts, :users, column: :author_id
    add_foreign_key :comments, :posts
    add_foreign_key :comments, :users, column: :author_id
    add_foreign_key :comments, :comments, column: :parent_comment_id
    add_foreign_key :likes, :users
    add_foreign_key :sprint_participants, :sprints
    add_foreign_key :sprint_participants, :users
  end
end
