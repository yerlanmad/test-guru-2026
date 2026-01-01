class Test < ApplicationRecord
  belongs_to :category
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :questions, dependent: :destroy
  has_many :test_results, dependent: :destroy
  has_many :users, through: :test_results

  validates :title, presence: true,
                    length: { minimum: 3, maximum: 200 },
                    uniqueness: { scope: :category_id }
  validates :level, presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 1,
                      less_than_or_equal_to: 10
                    }
  validates :category_id, presence: true
  validates :author_id, presence: true
  validates :description, length: { maximum: 2000 }, allow_blank: true
  validates :time_limit, numericality: {
                           only_integer: true,
                           greater_than: 0
                         }, allow_nil: true
  validates :passing_score, presence: true,
                            numericality: {
                              only_integer: true,
                              greater_than_or_equal_to: 0,
                              less_than_or_equal_to: 100
                            }

  scope :published, -> { where(published: true) }
  scope :by_level, ->(level) { where(level: level) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :ordered_by_title, -> { order(title: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  def self.titles_by_category(category_title)
    joins(:category)
      .where(categories: { title: category_title })
      .order(title: :desc)
      .pluck(:title)
  end

  def questions_count
    questions.count
  end

  def average_score
    test_results.where(status: 'completed').average(:score) || 0
  end
end
