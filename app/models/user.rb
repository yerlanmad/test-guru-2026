class User < ApplicationRecord
  ROLES = %w[student teacher admin].freeze

  has_secure_password

  has_many :authored_tests, class_name: 'Test',
                            foreign_key: 'author_id',
                            dependent: :nullify
  has_many :test_results, dependent: :destroy
  has_many :tests, through: :test_results

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true,
                       length: { minimum: 6 },
                       if: :password_digest_changed?
  validates :first_name, length: { maximum: 50 }, allow_blank: true
  validates :last_name, length: { maximum: 50 }, allow_blank: true
  validates :role, presence: true,
                   inclusion: { in: ROLES }

  before_save :downcase_email

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :students, -> { where(role: 'student') }
  scope :teachers, -> { where(role: 'teacher') }
  scope :admins, -> { where(role: 'admin') }

  def full_name
    "#{first_name} #{last_name}".strip.presence || email
  end

  def admin?
    role == 'admin'
  end

  def teacher?
    role == 'teacher'
  end

  def student?
    role == 'student'
  end

  def confirmed?
    confirmed_at.present?
  end

  def tests_by_level(level)
    tests.where(level: level).distinct
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
