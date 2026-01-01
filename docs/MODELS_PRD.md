# Product Requirements Document (PRD)
## TestGuru - Система онлайн-тестирования

**Дата создания:** 2025-12-31
**Версия:** 1.0
**Статус:** Implemented

---

## 1. ОБЗОР ПРОЕКТА

### 1.1 Технический стек
- **Framework:** Ruby on Rails 8.1.1
- **Ruby Version:** 3.4.5
- **Database:** SQLite3
- **Timezone:** Asia/Almaty
- **Locale:** :ru (Русский)
- **Testing:** Minitest
- **Authentication:** BCrypt (has_secure_password)

### 1.2 Цель системы
TestGuru - веб-приложение для создания, управления и прохождения образовательных тестов. Система позволяет организовать процесс тестирования знаний с отслеживанием результатов пользователей.

---

## 2. МОДЕЛИ ДАННЫХ

### 2.1 Category (Категория тестов)

**Назначение:** Организация тестов по тематическим категориям (например, "Программирование", "Математика", "Языки").

**Атрибуты:**
```ruby
# Таблица: categories
- id: bigint, primary key
- title: string, NOT NULL - название категории
- description: text, NULLABLE - описание категории
- created_at: datetime, NOT NULL
- updated_at: datetime, NOT NULL
```

**Валидации:**
- `title`: presence, length: { minimum: 2, maximum: 100 }, uniqueness: { case_sensitive: false }
- `description`: length: { maximum: 1000 }, allow_blank: true

**Связи:**
- `has_many :tests, dependent: :restrict_with_error`

**Индексы:**
- `index_categories_on_title` (unique)

---

### 2.2 User (Пользователь)

**Назначение:** Пользователи системы (студенты и авторы тестов).

**Атрибуты:**
```ruby
# Таблица: users
- id: bigint, primary key
- email: string, NOT NULL - email для входа
- password_digest: string, NOT NULL - хеш пароля (bcrypt)
- first_name: string, NULLABLE - имя
- last_name: string, NULLABLE - фамилия
- role: string, DEFAULT 'student', NOT NULL - роль пользователя
- confirmed_at: datetime, NULLABLE - дата подтверждения email
- last_sign_in_at: datetime, NULLABLE - последний вход
- created_at: datetime, NOT NULL
- updated_at: datetime, NOT NULL
```

**Валидации:**
- `email`: presence, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
- `password`: presence (on create), length: { minimum: 6 }
- `first_name`: length: { maximum: 50 }, allow_blank: true
- `last_name`: length: { maximum: 50 }, allow_blank: true
- `role`: presence, inclusion: { in: ['student', 'teacher', 'admin'] }

**Связи:**
- `has_many :authored_tests, class_name: 'Test', foreign_key: 'author_id', dependent: :nullify`
- `has_many :test_results, dependent: :destroy`
- `has_many :tests, through: :test_results`
- `has_secure_password`

**Индексы:**
- `index_users_on_email` (unique)
- `index_users_on_role`
- `index_users_on_last_sign_in_at`

---

### 2.3 Test (Тест)

**Назначение:** Основная сущность - тест с набором вопросов.

**Атрибуты:**
```ruby
# Таблица: tests
- id: bigint, primary key
- title: string, NOT NULL - название теста
- level: integer, DEFAULT 1, NOT NULL - уровень сложности (1-10)
- category_id: bigint, NOT NULL - внешний ключ на категорию
- author_id: bigint, NOT NULL - внешний ключ на автора теста
- description: text, NULLABLE - описание теста
- time_limit: integer, NULLABLE - лимит времени в минутах
- passing_score: integer, DEFAULT 70, NOT NULL - проходной балл в процентах
- published: boolean, DEFAULT false, NOT NULL - опубликован ли тест
- created_at: datetime, NOT NULL
- updated_at: datetime, NOT NULL
```

**Валидации:**
- `title`: presence, length: { minimum: 3, maximum: 200 }, uniqueness: { scope: :category_id }
- `level`: presence, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
- `category_id`: presence
- `author_id`: presence
- `description`: length: { maximum: 2000 }, allow_blank: true
- `time_limit`: numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
- `passing_score`: presence, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

**Связи:**
- `belongs_to :category`
- `belongs_to :author, class_name: 'User', foreign_key: 'author_id'`
- `has_many :questions, dependent: :destroy`
- `has_many :test_results, dependent: :destroy`
- `has_many :users, through: :test_results`

**Индексы:**
- `index_tests_on_category_id`
- `index_tests_on_author_id`
- `index_tests_on_level`
- `index_tests_on_published`
- `index_tests_on_title_and_category_id` (unique)

---

### 2.4 Question (Вопрос)

**Назначение:** Вопросы, входящие в состав теста.

**Атрибуты:**
```ruby
# Таблица: questions
- id: bigint, primary key
- test_id: bigint, NOT NULL - внешний ключ на тест
- body: text, NOT NULL - текст вопроса
- position: integer, DEFAULT 1, NOT NULL - порядковый номер вопроса в тесте
- question_type: string, DEFAULT 'single_choice', NOT NULL - тип вопроса
- points: integer, DEFAULT 1, NOT NULL - количество баллов за правильный ответ
- created_at: datetime, NOT NULL
- updated_at: datetime, NOT NULL
```

**Типы вопросов:**
- `single_choice` - один правильный ответ
- `multiple_choice` - несколько правильных ответов
- `text` - текстовый ответ

**Валидации:**
- `test_id`: presence
- `body`: presence, length: { minimum: 10, maximum: 2000 }
- `position`: presence, numericality: { only_integer: true, greater_than: 0 }
- `question_type`: presence, inclusion: { in: ['single_choice', 'multiple_choice', 'text'] }
- `points`: presence, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 100 }
- Кастомная валидация: минимум один правильный ответ для single/multiple choice

**Связи:**
- `belongs_to :test`
- `has_many :answers, dependent: :destroy`

**Индексы:**
- `index_questions_on_test_id`
- `index_questions_on_test_id_and_position`

---

### 2.5 Answer (Ответ)

**Назначение:** Варианты ответов на вопросы.

**Атрибуты:**
```ruby
# Таблица: answers
- id: bigint, primary key
- question_id: bigint, NOT NULL - внешний ключ на вопрос
- body: text, NOT NULL - текст ответа
- is_correct: boolean, DEFAULT false, NOT NULL - флаг правильности ответа
- position: integer, DEFAULT 1, NOT NULL - порядковый номер ответа
- created_at: datetime, NOT NULL
- updated_at: datetime, NOT NULL
```

**Валидации:**
- `question_id`: presence
- `body`: presence, length: { minimum: 1, maximum: 500 }
- `is_correct`: inclusion: { in: [true, false] }
- `position`: presence, numericality: { only_integer: true, greater_than: 0 }

**Связи:**
- `belongs_to :question`

**Индексы:**
- `index_answers_on_question_id`
- `index_answers_on_question_id_and_is_correct`

---

### 2.6 TestResult (Результат прохождения теста)

**Назначение:** Join-модель для связи User и Test с дополнительными данными о прохождении теста.

**Атрибуты:**
```ruby
# Таблица: test_results
- id: bigint, primary key
- user_id: bigint, NOT NULL - внешний ключ на пользователя
- test_id: bigint, NOT NULL - внешний ключ на тест
- score: decimal(5,2), DEFAULT 0.0, NOT NULL - результат в процентах (0.00 - 100.00)
- correct_answers: integer, DEFAULT 0, NOT NULL - количество правильных ответов
- total_questions: integer, NOT NULL - общее количество вопросов в тесте
- status: string, DEFAULT 'in_progress', NOT NULL - статус прохождения
- started_at: datetime, NOT NULL - время начала прохождения
- completed_at: datetime, NULLABLE - время завершения
- time_spent: integer, NULLABLE - время прохождения в секундах
- created_at: datetime, NOT NULL
- updated_at: datetime, NOT NULL
```

**Статусы:**
- `in_progress` - тест в процессе прохождения
- `completed` - тест завершён
- `failed` - тест провален
- `abandoned` - тест брошен

**Валидации:**
- `user_id`: presence
- `test_id`: presence
- `score`: presence, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
- `correct_answers`: presence, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
- `total_questions`: presence, numericality: { only_integer: true, greater_than: 0 }
- `status`: presence, inclusion: { in: ['in_progress', 'completed', 'failed', 'abandoned'] }
- `started_at`: presence
- `time_spent`: numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
- Кастомная валидация: `correct_answers <= total_questions`

**Связи:**
- `belongs_to :user`
- `belongs_to :test`

**Индексы:**
- `index_test_results_on_user_id`
- `index_test_results_on_test_id`
- `index_test_results_on_user_id_and_test_id`
- `index_test_results_on_status`
- `index_test_results_on_score`
- `index_test_results_on_created_at`

**Методы:**
- `passed?` - проверка, сдан ли тест
- `failed?` - проверка, провален ли тест
- `calculate_score` - расчёт процента правильных ответов
- `complete!` - завершение прохождения теста с автоматическим расчётом

---

## 3. ДИАГРАММА СВЯЗЕЙ (ERD)

```
┌─────────────┐
│  Category   │
│─────────────│
│ id          │
│ title       │
│ description │
└─────────────┘
       │
       │ 1:N
       ▼
┌─────────────────┐
│      Test       │
│─────────────────│
│ id              │
│ title           │
│ level           │
│ category_id     │──┐
│ author_id       │  │
│ description     │  │
│ time_limit      │  │
│ passing_score   │  │
│ published       │  │
└─────────────────┘  │
       │             │
       │ 1:N         │
       ▼             │
┌─────────────────┐  │
│    Question     │  │
│─────────────────│  │
│ id              │  │
│ test_id         │  │
│ body            │  │
│ position        │  │
│ question_type   │  │
│ points          │  │
└─────────────────┘  │
       │             │
       │ 1:N         │
       ▼             │
┌─────────────────┐  │
│     Answer      │  │
│─────────────────│  │
│ id              │  │
│ question_id     │  │
│ body            │  │
│ is_correct      │  │
│ position        │  │
└─────────────────┘  │
                     │
┌─────────────────┐  │
│      User       │  │
│─────────────────│  │
│ id              │  │
│ email           │  │
│ password_digest │  │
│ first_name      │  │
│ last_name       │  │
│ role            │  │
│ confirmed_at    │  │
│ last_sign_in_at │  │
└─────────────────┘  │
       │             │
       │ 1:N         │
       │             │
       ▼             │
┌─────────────────┐  │
│  TestResult     │  │
│─────────────────│  │
│ id              │  │
│ user_id         │◄─┘
│ test_id         │◄───┐
│ score           │    │
│ correct_answers │    │ N:M
│ total_questions │    │ (через TestResult)
│ status          │    │
│ started_at      │    │
│ completed_at    │    │
│ time_spent      │    │
└─────────────────┘    │
                       │
                Test ──┘
```

---

## 4. РЕАЛИЗОВАННЫЕ ВОЗМОЖНОСТИ

### 4.1 Категоризация тестов
- Организация тестов по категориям
- Уникальные названия категорий
- Ограничение на удаление категории с тестами

### 4.2 Система ролей пользователей
- **Student** - может проходить тесты
- **Teacher** - может создавать и управлять тестами
- **Admin** - полный доступ к системе

### 4.3 Управление тестами
- Создание тестов с описанием и уровнем сложности
- Назначение автора теста
- Публикация/снятие с публикации
- Установка проходного балла
- Ограничение по времени (опционально)

### 4.4 Типы вопросов
- **Single choice** - один правильный ответ
- **Multiple choice** - несколько правильных ответов
- **Text** - текстовый ответ (для будущей реализации)

### 4.5 Отслеживание результатов
- Запись времени начала и завершения
- Автоматический расчёт процента правильных ответов
- Определение статуса (сдано/не сдано)
- Учёт времени прохождения

---

## 5. ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ

### 5.1 Создание теста с вопросами

```ruby
# Создание категории
category = Category.create!(title: 'Ruby', description: 'Тесты по Ruby')

# Создание автора
teacher = User.create!(
  email: 'teacher@example.com',
  password: 'password',
  role: 'teacher'
)

# Создание теста
test = Test.create!(
  title: 'Основы Ruby',
  level: 1,
  category: category,
  author: teacher,
  passing_score: 70,
  published: true
)

# Создание вопроса
question = test.questions.create!(
  body: 'Что такое Ruby?',
  position: 1,
  question_type: 'single_choice'
)

# Создание ответов
question.answers.create!([
  { body: 'Язык программирования', is_correct: true, position: 1 },
  { body: 'База данных', is_correct: false, position: 2 }
])
```

### 5.2 Прохождение теста

```ruby
student = User.find_by(email: 'student@example.com')
test = Test.find_by(title: 'Основы Ruby')

# Начало прохождения
result = TestResult.create!(
  user: student,
  test: test,
  total_questions: test.questions.count,
  started_at: Time.current
)

# Завершение теста
result.correct_answers = 8
result.complete!

# Проверка результата
result.passed? # => true или false
```

---

## 6. ТЕКУЩИЙ СТАТУС

### 6.1 Реализовано ✅
- Все 6 моделей с валидациями
- 7 миграций успешно применены
- Seed данные для разработки
- Полная структура связей
- Индексы для оптимизации

### 6.2 База данных (после seed)
- Категорий: 4
- Пользователей: 3 (admin, teacher, student)
- Тестов: 3
- Вопросов: 4
- Ответов: 14

---

## 7. СЛЕДУЮЩИЕ ШАГИ

### Фаза 1: Контроллеры и Views
- Контроллеры для CRUD операций
- Страницы для отображения тестов
- Формы для создания/редактирования

### Фаза 2: Логика прохождения тестов
- Интерфейс прохождения теста
- Сохранение ответов пользователя
- Подсчёт результатов

### Фаза 3: Аутентификация
- Регистрация и вход пользователей
- Управление сессиями
- Разграничение доступа по ролям

### Фаза 4: Улучшения
- Статистика и аналитика
- Экспорт результатов
- Таймер для тестов с ограничением времени

---

**Документ готов к использованию для дальнейшей разработки.**
