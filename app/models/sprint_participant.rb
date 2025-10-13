class SprintParticipant < ApplicationRecord
  # Ассоциации
  belongs_to :sprint
  belongs_to :user

  # Валидации
  validates :sprint_participant_id, presence: true, uniqueness: true
  validates :sprint_id, presence: true
  validates :user_id, presence: true
  validates :progress_status, inclusion: { in: ['not_started', 'in_progress', 'completed', 'dropped'] }
  validates :user_id, uniqueness: { scope: :sprint_id, message: "уже участвует в этом спринте" }

  # Колбэки
  before_validation :set_sprint_participant_id, on: :create
  before_validation :set_join_date, on: :create

  # Scopes
  scope :active, -> { where(progress_status: ['not_started', 'in_progress']) }
  scope :completed, -> { where(progress_status: 'completed') }
  scope :dropped, -> { where(progress_status: 'dropped') }

  # Методы
  def is_active?
    ['not_started', 'in_progress'].include?(progress_status)
  end

  def is_completed?
    progress_status == 'completed'
  end

  def is_dropped?
    progress_status == 'dropped'
  end

  def progress_percentage
    case progress_status
    when 'not_started'
      0
    when 'in_progress'
      50
    when 'completed'
      100
    when 'dropped'
      0
    else
      0
    end
  end

  def status_in_russian
    case progress_status
    when 'not_started'
      'Не начат'
    when 'in_progress'
      'В процессе'
    when 'completed'
      'Завершен'
    when 'dropped'
      'Брошен'
    else
      'Неизвестно'
    end
  end

  def days_participated
    return 0 unless join_date
    
    end_date = sprint.end_date
    end_date = Time.current if Time.current < end_date
    
    (end_date.to_date - join_date.to_date).to_i
  end

  private

  def set_sprint_participant_id
    self.sprint_participant_id ||= generate_unique_sprint_participant_id
  end

  def set_join_date
    self.join_date ||= Time.current
  end

  def generate_unique_sprint_participant_id
    loop do
      id = SecureRandom.random_number(1_000_000_000)
      break id unless SprintParticipant.exists?(sprint_participant_id: id)
    end
  end
end
