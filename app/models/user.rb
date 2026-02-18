class User < ApplicationRecord
  # Ассоциации
  has_many :posts, foreign_key: "author_id", dependent: :destroy
  has_many :comments, foreign_key: "author_id", dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :sprint_participants, dependent: :destroy
  has_many :sprints, through: :sprint_participants
  has_many :liked_posts, through: :likes, source: :target, source_type: "Post"
  has_many :liked_comments, through: :likes, source: :target, source_type: "Comment"

  # Валидации
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_hash, presence: true

  # Колбэки
  before_validation :set_registration_date, on: :create

  # Методы
  def full_name
    username
  end

  def posts_count
    posts.count
  end

  def comments_count
    comments.count
  end

  def likes_count
    likes.count
  end

  def active_sprints_count
    sprints.active.count
  end

  def completed_sprints_count
    sprint_participants.completed.count
  end

  def has_liked?(target)
    likes.exists?(target: target)
  end

  def like(target)
    return false if has_liked?(target)
    likes.create(target: target)
  end

  def unlike(target)
    like_record = likes.find_by(target: target)
    like_record&.destroy
  end

  private

  def set_registration_date
    self.registration_date ||= Time.current
  end
end
