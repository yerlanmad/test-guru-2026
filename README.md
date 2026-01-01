# TestGuru

Веб-приложение для создания, управления и прохождения образовательных тестов.

## Технический стек

- **Ruby:** 3.4.5
- **Rails:** 8.1.1
- **Database:** SQLite3
- **Authentication:** BCrypt (has_secure_password)
- **Frontend:** Hotwire (Turbo + Stimulus), Importmap
- **Background Jobs:** Solid Queue
- **Cache:** Solid Cache

## Модели данных

Приложение включает следующие модели:

- **Category** - категории тестов
- **User** - пользователи с ролями (student, teacher, admin)
- **Test** - тесты с вопросами
- **Question** - вопросы с разными типами (single_choice, multiple_choice, text)
- **Answer** - варианты ответов с флагом правильности
- **TestResult** - результаты прохождения тестов пользователями

Подробная документация: [docs/MODELS_PRD.md](docs/MODELS_PRD.md)

## Настройка проекта

### Требования

- Ruby 3.4.5
- SQLite3
- Bundler

### Установка

```bash
# Клонирование репозитория
git clone <repository-url>
cd test-guru

# Установка зависимостей
bundle install

# Настройка базы данных
bin/rails db:setup

# Запуск сервера
bin/dev
```

## База данных

### Создание и миграции

```bash
# Создание базы данных
bin/rails db:create

# Применение миграций
bin/rails db:migrate

# Загрузка seed данных
bin/rails db:seed
```

### Seed данные

После выполнения `bin/rails db:seed` будут созданы:
- 4 категории (Программирование, Математика, Ruby on Rails, Frontend)
- 3 пользователя:
  - admin@testguru.local / password (admin)
  - teacher@testguru.local / password (teacher)
  - student@testguru.local / password (student)
- 3 теста с вопросами и ответами

## Разработка

### Запуск тестов

```bash
# Все тесты
bin/rails test

# Только модели
bin/rails test:models

# Конкретный файл
bin/rails test test/models/test_test.rb
```

### Консоль

```bash
bin/rails console
```

### Проверка кода

```bash
# Стиль кода (RuboCop)
bin/rubocop

# Безопасность
bin/brakeman
bin/bundler-audit

# CI pipeline
bin/ci
```

## Конфигурация

- **Timezone:** Asia/Almaty
- **Default Locale:** Russian (:ru)
- **Passing Score:** 70% (по умолчанию)

## Документация

- [Product Requirements Document](docs/MODELS_PRD.md) - полная документация моделей
- [Claude Code Guide](CLAUDE.md) - руководство для Claude Code

## Лицензия

Этот проект создан в образовательных целях.
