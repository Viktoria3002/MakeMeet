class Like < ApplicationRecord
  # Ассоциации
  belongs_to :user
  belongs_to :target, polymorphic: true

  # Валидации
  validates :like_id, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :target_type, presence: true, inclusion: { in: ['Post', 'Comment'] }
  validates :target_id, presence: true
  validates :user_id, uniqueness: { scope: [:target_type, :target_id], message: "уже лайкнул этот объект" }

  # Колбэки
  before_validation :set_like_id, on: :create

  # Методы
  def target_name
    case target_type
    when 'Post'
      "пост"
    when 'Comment'
      "комментарий"
    else
      "объект"
    end
  end

  def self.for_posts
    where(target_type: 'Post')
  end

  def self.for_comments
    where(target_type: 'Comment')
  end

  private

  def set_like_id
    self.like_id ||= generate_unique_like_id
  end

  def generate_unique_like_id
    loop do
      id = SecureRandom.random_number(1_000_000_000)
      break id unless Like.exists?(like_id: id)
    end
  end
end
