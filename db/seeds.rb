puts 'Очистка базы данных...'
TestResult.destroy_all
Answer.destroy_all
Question.destroy_all
Test.destroy_all
Category.destroy_all
User.destroy_all

puts 'Создание категорий...'
programming = Category.create!(title: 'Программирование', description: 'Тесты по программированию')
mathematics = Category.create!(title: 'Математика', description: 'Математические тесты')
rails_category = Category.create!(title: 'Ruby on Rails', description: 'Тесты по фреймворку Rails')
frontend = Category.create!(title: 'Frontend', description: 'HTML, CSS, JavaScript')

puts 'Создание пользователей...'
admin = User.create!(
  email: 'admin@testguru.local',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Администратор',
  role: 'admin',
  confirmed_at: Time.current
)

teacher = User.create!(
  email: 'teacher@testguru.local',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Преподаватель',
  last_name: 'Иванов',
  role: 'teacher',
  confirmed_at: Time.current
)

student = User.create!(
  email: 'student@testguru.local',
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Студент',
  last_name: 'Петров',
  role: 'student',
  confirmed_at: Time.current
)

puts 'Создание тестов...'
test1 = Test.create!(
  title: 'Основы Ruby',
  level: 1,
  category: programming,
  author: teacher,
  description: 'Базовые концепции языка Ruby',
  passing_score: 70,
  published: true
)

test2 = Test.create!(
  title: 'Ruby on Rails для начинающих',
  level: 2,
  category: rails_category,
  author: teacher,
  description: 'Введение в Rails',
  time_limit: 30,
  passing_score: 75,
  published: true
)

test3 = Test.create!(
  title: 'HTML и CSS',
  level: 1,
  category: frontend,
  author: teacher,
  description: 'Основы верстки',
  passing_score: 60,
  published: true
)

puts 'Создание вопросов и ответов...'
q1 = Question.create!(
  test: test1,
  body: 'Что такое Ruby?',
  position: 1,
  question_type: 'single_choice',
  points: 1
)

Answer.create!([
  { question: q1, body: 'Язык программирования', is_correct: true, position: 1 },
  { question: q1, body: 'Драгоценный камень', is_correct: false, position: 2 },
  { question: q1, body: 'Фреймворк', is_correct: false, position: 3 },
  { question: q1, body: 'База данных', is_correct: false, position: 4 }
])

q2 = Question.create!(
  test: test1,
  body: 'Какие из следующих типов данных есть в Ruby? (выберите все подходящие)',
  position: 2,
  question_type: 'multiple_choice',
  points: 2
)

Answer.create!([
  { question: q2, body: 'String', is_correct: true, position: 1 },
  { question: q2, body: 'Integer', is_correct: true, position: 2 },
  { question: q2, body: 'Boolean', is_correct: false, position: 3 },
  { question: q2, body: 'Array', is_correct: true, position: 4 }
])

q3 = Question.create!(
  test: test2,
  body: 'Что такое MVC?',
  position: 1,
  question_type: 'single_choice',
  points: 1
)

Answer.create!([
  { question: q3, body: 'Model-View-Controller (архитектурный паттерн)', is_correct: true, position: 1 },
  { question: q3, body: 'Most Valuable Code', is_correct: false, position: 2 },
  { question: q3, body: 'Multi-Version Control', is_correct: false, position: 3 }
])

q4 = Question.create!(
  test: test3,
  body: 'Что означает тег <div>?',
  position: 1,
  question_type: 'single_choice',
  points: 1
)

Answer.create!([
  { question: q4, body: 'Блочный элемент для группировки содержимого', is_correct: true, position: 1 },
  { question: q4, body: 'Деление текста', is_correct: false, position: 2 },
  { question: q4, body: 'Диаграмма', is_correct: false, position: 3 }
])

puts 'Готово! Создано:'
puts "  Категорий: #{Category.count}"
puts "  Пользователей: #{User.count}"
puts "  Тестов: #{Test.count}"
puts "  Вопросов: #{Question.count}"
puts "  Ответов: #{Answer.count}"
