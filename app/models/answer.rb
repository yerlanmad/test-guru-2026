class Answer < ApplicationRecord
  belongs_to :question

  validates :question_id, presence: true
  validates :body, presence: true,
                   length: { minimum: 1, maximum: 500 }
  validates :is_correct, inclusion: { in: [true, false] }
  validates :position, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }

  scope :correct, -> { where(is_correct: true) }
  scope :incorrect, -> { where(is_correct: false) }
  scope :ordered, -> { order(position: :asc) }
end
