class TestResult < ApplicationRecord
  STATUSES = %w[in_progress completed failed abandoned].freeze

  belongs_to :user
  belongs_to :test

  validates :user_id, presence: true
  validates :test_id, presence: true
  validates :score, presence: true,
                    numericality: {
                      greater_than_or_equal_to: 0,
                      less_than_or_equal_to: 100
                    }
  validates :correct_answers, presence: true,
                              numericality: {
                                only_integer: true,
                                greater_than_or_equal_to: 0
                              }
  validates :total_questions, presence: true,
                              numericality: {
                                only_integer: true,
                                greater_than: 0
                              }
  validates :status, presence: true,
                     inclusion: { in: STATUSES }
  validates :started_at, presence: true
  validates :time_spent, numericality: {
                           only_integer: true,
                           greater_than_or_equal_to: 0
                         }, allow_nil: true
  validate :correct_answers_cannot_exceed_total_questions

  scope :completed, -> { where(status: 'completed') }
  scope :in_progress, -> { where(status: 'in_progress') }
  scope :passed, ->(passing_score = 70) { where('score >= ?', passing_score) }
  scope :failed, ->(passing_score = 70) {
    where('score < ?', passing_score).where(status: 'completed')
  }
  scope :recent, -> { order(created_at: :desc) }

  def passed?
    status == 'completed' && score >= test.passing_score
  end

  def failed?
    status == 'completed' && score < test.passing_score
  end

  def in_progress?
    status == 'in_progress'
  end

  def calculate_score
    return 0 if total_questions.zero?
    ((correct_answers.to_f / total_questions) * 100).round(2)
  end

  def complete!
    update(
      status: 'completed',
      completed_at: Time.current,
      time_spent: started_at ? (Time.current - started_at).to_i : nil,
      score: calculate_score
    )
  end

  private

  def correct_answers_cannot_exceed_total_questions
    if correct_answers.present? && total_questions.present? &&
       correct_answers > total_questions
      errors.add(:correct_answers,
                 'не может быть больше общего количества вопросов')
    end
  end
end
