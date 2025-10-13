# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Очистка существующих данных
User.destroy_all
Post.destroy_all
Comment.destroy_all
Like.destroy_all
Sprint.destroy_all
SprintParticipant.destroy_all

puts "Создание пользователей..."

# Создание пользователей
users = [
  { username: "alex_dev", email: "alex@example.com", password_hash: "hashed_password_1" },
  { username: "maria_designer", email: "maria@example.com", password_hash: "hashed_password_2" },
  { username: "ivan_manager", email: "ivan@example.com", password_hash: "hashed_password_3" },
  { username: "anna_developer", email: "anna@example.com", password_hash: "hashed_password_4" },
  { username: "dmitry_tester", email: "dmitry@example.com", password_hash: "hashed_password_5" }
]

created_users = []
users.each do |user_data|
  user = User.create!(user_data)
  created_users << user
  puts "Создан пользователь: #{user.username}"
end

puts "Создание постов..."

# Создание постов
posts = [
  { author: created_users[0], content: "Привет всем! Сегодня начал изучение Ruby on Rails. Очень интересный фреймворк!" },
  { author: created_users[1], content: "Поделюсь своим опытом работы с дизайном. Главное - это понимание пользователя." },
  { author: created_users[2], content: "Планируем новый проект. Нужны идеи для улучшения UX." },
  { author: created_users[3], content: "Закончила работу над новым функционалом. Тестирование показало отличные результаты!" },
  { author: created_users[4], content: "Нашел интересный баг в коде. Думаю, как лучше его исправить." }
]

created_posts = []
posts.each do |post_data|
  post = Post.create!(post_data)
  created_posts << post
  puts "Создан пост: #{post.content[0..50]}..."
end

puts "Создание комментариев..."

# Создание комментариев
comments = [
  { post: created_posts[0], author: created_users[1], content: "Отлично! Rails действительно мощный фреймворк. Удачи в изучении!" },
  { post: created_posts[0], author: created_users[2], content: "Согласен с Марией. Если нужна помощь - обращайся!" },
  { post: created_posts[1], author: created_users[0], content: "Интересные мысли о дизайне. А как ты изучаешь потребности пользователей?" },
  { post: created_posts[2], author: created_users[3], content: "Предлагаю добавить темную тему. Это сейчас очень популярно." },
  { post: created_posts[3], author: created_users[4], content: "Поздравляю с успешным завершением! Какие метрики улучшились?" }
]

created_comments = []
comments.each do |comment_data|
  comment = Comment.create!(comment_data)
  created_comments << comment
  puts "Создан комментарий: #{comment.content[0..30]}..."
end

# Создание ответов на комментарии
replies = [
  { post: created_posts[0], author: created_users[0], content: "Спасибо за поддержку! Обязательно воспользуюсь советом.", parent_comment: created_comments[0] },
  { post: created_posts[1], author: created_users[1], content: "Обычно провожу интервью и анализирую поведение пользователей.", parent_comment: created_comments[2] }
]

replies.each do |reply_data|
  comment = Comment.create!(reply_data)
  puts "Создан ответ: #{comment.content[0..30]}..."
end

puts "Создание лайков..."

# Создание лайков
likes_data = [
  { user: created_users[1], target: created_posts[0] },
  { user: created_users[2], target: created_posts[0] },
  { user: created_users[3], target: created_posts[1] },
  { user: created_users[4], target: created_posts[1] },
  { user: created_users[0], target: created_posts[2] },
  { user: created_users[1], target: created_comments[0] },
  { user: created_users[3], target: created_comments[1] }
]

likes_data.each do |like_data|
  Like.create!(like_data)
  puts "Создан лайк для #{like_data[:target].class.name}"
end

puts "Создание спринтов..."

# Создание спринтов
sprints = [
  { 
    name: "Изучение Ruby on Rails", 
    description: "30-дневный марафон по изучению основ Ruby on Rails для начинающих разработчиков", 
    start_date: Date.current, 
    end_date: Date.current + 30.days 
  },
  { 
    name: "UI/UX Дизайн", 
    description: "Интенсивный курс по современному дизайну интерфейсов и пользовательского опыта", 
    start_date: Date.current + 7.days, 
    end_date: Date.current + 37.days 
  },
  { 
    name: "Тестирование ПО", 
    description: "Практический курс по автоматизированному и ручному тестированию приложений", 
    start_date: Date.current - 5.days, 
    end_date: Date.current + 25.days 
  }
]

created_sprints = []
sprints.each do |sprint_data|
  sprint = Sprint.create!(sprint_data)
  created_sprints << sprint
  puts "Создан спринт: #{sprint.name}"
end

puts "Создание участников спринтов..."

# Создание участников спринтов
sprint_participants = [
  { sprint: created_sprints[0], user: created_users[0], progress_status: "in_progress" },
  { sprint: created_sprints[0], user: created_users[3], progress_status: "in_progress" },
  { sprint: created_sprints[1], user: created_users[1], progress_status: "not_started" },
  { sprint: created_sprints[1], user: created_users[2], progress_status: "not_started" },
  { sprint: created_sprints[2], user: created_users[4], progress_status: "in_progress" },
  { sprint: created_sprints[2], user: created_users[0], progress_status: "completed" }
]

sprint_participants.each do |participant_data|
  SprintParticipant.create!(participant_data)
  puts "Добавлен участник #{participant_data[:user].username} в спринт #{participant_data[:sprint].name}"
end

puts "База данных успешно заполнена!"
puts "Статистика:"
puts "- Пользователей: #{User.count}"
puts "- Постов: #{Post.count}"
puts "- Комментариев: #{Comment.count}"
puts "- Лайков: #{Like.count}"
puts "- Спринтов: #{Sprint.count}"
puts "- Участников спринтов: #{SprintParticipant.count}"