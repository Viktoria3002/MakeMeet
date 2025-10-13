class Comment < ApplicationRecord
  # Ассоциации
  belongs_to :post
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  has_many :likes, as: :target, dependent: :destroy

  # Валидации
  validates :comment_id, presence: true, uniqueness: true
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
  validates :post_id, presence: true
  validates :author_id, presence: true

  # Колбэки
  before_validation :set_comment_id, on: :create

  # Методы
  def likes_count
    likes.count
  end

  def replies_count
    replies.count
  end

  def is_reply?
    parent_comment_id.present?
  end

  def root_comment
    return self unless parent_comment_id
    parent_comment.root_comment
  end

  def all_replies
    replies.includes(:author, :replies).order(:created_at)
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

  def set_comment_id
    self.comment_id ||= generate_unique_comment_id
  end

  def generate_unique_comment_id
    loop do
      id = SecureRandom.random_number(1_000_000_000)
      break id unless Comment.exists?(comment_id: id)
    end
  end
end
