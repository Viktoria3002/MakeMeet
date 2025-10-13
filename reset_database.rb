#!/usr/bin/env ruby

# Скрипт для сброса и пересоздания базы данных
puts "Сброс базы данных..."

# Удаляем базу данных если она существует
db_path = "storage/development.sqlite3"
if File.exist?(db_path)
  File.delete(db_path)
  puts "База данных удалена"
end

# Создаем новую базу данных
puts "Создание новой базы данных..."

# Загружаем Rails приложение
require_relative 'config/environment'

# Создаем таблицы
ActiveRecord::Base.connection.create_table :users, force: true do |t|
  t.integer :user_id
  t.string :username, null: false
  t.string :email, null: false
  t.string :password_hash, null: false
  t.datetime :registration_date
  t.timestamps
end

ActiveRecord::Base.connection.add_index :users, :user_id, unique: true
ActiveRecord::Base.connection.add_index :users, :username, unique: true
ActiveRecord::Base.connection.add_index :users, :email, unique: true

ActiveRecord::Base.connection.create_table :posts, force: true do |t|
  t.integer :post_id, null: false
  t.bigint :author_id, null: false
  t.text :content, null: false
  t.timestamps
end

ActiveRecord::Base.connection.add_index :posts, :post_id, unique: true
ActiveRecord::Base.connection.add_index :posts, :author_id
ActiveRecord::Base.connection.add_index :posts, :created_at

ActiveRecord::Base.connection.create_table :comments, force: true do |t|
  t.integer :comment_id, null: false
  t.bigint :post_id, null: false
  t.bigint :author_id, null: false
  t.text :content, null: false
  t.bigint :parent_comment_id
  t.timestamps
end

ActiveRecord::Base.connection.add_index :comments, :comment_id, unique: true
ActiveRecord::Base.connection.add_index :comments, :post_id
ActiveRecord::Base.connection.add_index :comments, :author_id
ActiveRecord::Base.connection.add_index :comments, :parent_comment_id
ActiveRecord::Base.connection.add_index :comments, :created_at

ActiveRecord::Base.connection.create_table :likes, force: true do |t|
  t.integer :like_id, null: false
  t.bigint :user_id, null: false
  t.string :target_type, null: false
  t.integer :target_id, null: false
  t.timestamps
end

ActiveRecord::Base.connection.add_index :likes, :like_id, unique: true
ActiveRecord::Base.connection.add_index :likes, [:user_id, :target_type, :target_id], unique: true
ActiveRecord::Base.connection.add_index :likes, [:target_type, :target_id]
ActiveRecord::Base.connection.add_index :likes, :created_at

ActiveRecord::Base.connection.create_table :sprints, force: true do |t|
  t.integer :sprint_id, null: false
  t.string :name, null: false
  t.text :description, null: false
  t.date :start_date, null: false
  t.date :end_date, null: false
  t.timestamps
end

ActiveRecord::Base.connection.add_index :sprints, :sprint_id, unique: true
ActiveRecord::Base.connection.add_index :sprints, :start_date
ActiveRecord::Base.connection.add_index :sprints, :end_date

ActiveRecord::Base.connection.create_table :sprint_participants, force: true do |t|
  t.integer :sprint_participant_id, null: false
  t.bigint :sprint_id, null: false
  t.bigint :user_id, null: false
  t.datetime :join_date
  t.string :progress_status, default: 'not_started'
  t.timestamps
end

ActiveRecord::Base.connection.add_index :sprint_participants, :sprint_participant_id, unique: true
ActiveRecord::Base.connection.add_index :sprint_participants, [:sprint_id, :user_id], unique: true
ActiveRecord::Base.connection.add_index :sprint_participants, :progress_status
ActiveRecord::Base.connection.add_index :sprint_participants, :join_date

puts "База данных успешно создана!"
puts "Таблицы созданы:"
puts "- users"
puts "- posts" 
puts "- comments"
puts "- likes"
puts "- sprints"
puts "- sprint_participants"
