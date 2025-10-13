class Post < ApplicationRecord
  # Ассоциации
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :comments, dependent: :destroy
  has_many :likes, as: :target, dependent: :destroy

  # Валидации
  validates :post_id, presence: true, uniqueness: true
  validates :content, presence: true, length: { minimum: 1, maximum: 5000 }
  validates :author_id, presence: true

  # Колбэки
  before_validation :set_post_id, on: :create

  # Методы
  def comments_count
    comments.count
  end

  def likes_count
    likes.count
  end

  def nested_comments
    comments.where(parent_comment_id: nil)
  end

  def all_comments_with_replies
    comments.includes(:author).order(:created_at)
  end

  def has_user_liked?(user)
    return false unless user
    likes.exists?(user: user)
  end

  def toggle_like(user)
    return false unless user
    
    if has_user_liked?(user)
      unlike_by(user)
    else
      like_by(user)
    end
  end

  def like_by(user)
    return false unless user
    return false if has_user_liked?(user)
    likes.create(user: user)
  end

  def unlike_by(user)
    return false unless user
    like_record = likes.find_by(user: user)
    like_record&.destroy
  end

  private

  def set_post_id
    self.post_id ||= generate_unique_post_id
  end

  def generate_unique_post_id
    loop do
      id = SecureRandom.random_number(1_000_000_000)
      break id unless Post.exists?(post_id: id)
    end
  end
end
