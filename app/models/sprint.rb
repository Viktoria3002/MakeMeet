class Sprint < ApplicationRecord
  # Ассоциации
  has_many :sprint_participants, dependent: :destroy
  has_many :users, through: :sprint_participants

  # Валидации
  validates :sprint_id, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  # Колбэки
  before_validation :set_sprint_id, on: :create

  # Scopes
  scope :active, -> { where("start_date <= ? AND end_date >= ?", Date.current, Date.current) }
  scope :upcoming, -> { where("start_date > ?", Date.current) }
  scope :completed, -> { where("end_date < ?", Date.current) }

  # Методы
  def participants_count
    sprint_participants.count
  end

  def is_active?
    Date.current.between?(start_date, end_date)
  end

  def is_upcoming?
    start_date > Date.current
  end

  def is_completed?
    end_date < Date.current
  end

  def duration_days
    (end_date - start_date).to_i / 1.day
  end

  def days_remaining
    return 0 if is_completed?
    (end_date - Date.current).to_i
  end

  def progress_percentage
    return 100 if is_completed?
    return 0 if is_upcoming?

    total_duration = (end_date - start_date).to_i
    elapsed_days = (Date.current - start_date).to_i
    (elapsed_days.to_f / total_duration * 100).round(2)
  end

  private

  def set_sprint_id
    self.sprint_id ||= generate_unique_sprint_id
  end

  def generate_unique_sprint_id
    loop do
      id = SecureRandom.random_number(1_000_000_000)
      break id unless Sprint.exists?(sprint_id: id)
    end
  end

  def end_date_after_start_date
    return unless start_date && end_date

    if end_date <= start_date
      errors.add(:end_date, "должна быть после даты начала")
    end
  end
end
