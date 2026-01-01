class Category < ApplicationRecord
  has_many :tests, dependent: :restrict_with_error

  validates :title, presence: true,
                    length: { minimum: 2, maximum: 100 },
                    uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 1000 }, allow_blank: true

  scope :ordered, -> { order(title: :asc) }
  scope :with_tests, -> { joins(:tests).distinct }

  def tests_count
    tests.count
  end
end
