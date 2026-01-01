class Question < ApplicationRecord
  QUESTION_TYPES = %w[single_choice multiple_choice text].freeze

  belongs_to :test
  has_many :answers, dependent: :destroy

  validates :test_id, presence: true
  validates :body, presence: true,
                   length: { minimum: 10, maximum: 2000 }
  validates :position, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }
  validates :question_type, presence: true,
                            inclusion: { in: QUESTION_TYPES }
  validates :points, presence: true,
                     numericality: {
                       only_integer: true,
                       greater_than: 0,
                       less_than_or_equal_to: 100
                     }
  validate :at_least_one_correct_answer, on: :update

  scope :ordered, -> { order(position: :asc) }
  scope :by_type, ->(type) { where(question_type: type) }

  def correct_answers
    answers.where(is_correct: true)
  end

  def incorrect_answers
    answers.where(is_correct: false)
  end

  private

  def at_least_one_correct_answer
    return if answers.empty?

    if question_type.in?(['single_choice', 'multiple_choice']) && correct_answers.empty?
      errors.add(:base, 'Вопрос должен иметь хотя бы один правильный ответ')
    end
  end
end
