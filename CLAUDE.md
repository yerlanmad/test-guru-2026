# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TestGuru is a Ruby on Rails 8.1 application for managing educational tests. The application is configured with Russian localization (default locale: `:ru`) and Asia/Almaty timezone.

## Technology Stack

- **Rails**: 8.1.1
- **Ruby**: 3.4.5
- **Database**: SQLite3 (development/test)
- **Asset Pipeline**: Propshaft
- **Frontend**: Hotwire (Turbo + Stimulus), Importmap
- **Background Jobs**: Solid Queue
- **Cache**: Solid Cache
- **WebSocket**: Solid Cable
- **Deployment**: Kamal (Docker-based)

## Development Commands

### Setup
```bash
bin/setup                    # Initial setup
bin/rails db:migrate         # Run database migrations
bin/rails db:seed            # Seed the database
```

### Server
```bash
bin/dev                      # Start development server
```

### Testing
```bash
bin/rails test               # Run all tests
bin/rails test:system        # Run system tests
bin/rails test test/models/test_test.rb  # Run single test file
```

### Code Quality & Security
```bash
bin/rubocop                  # Ruby style linting (Omakase)
bin/brakeman                 # Security analysis
bin/bundler-audit            # Gem vulnerability audit
bin/importmap audit          # Importmap vulnerability audit
bin/ci                       # Run full CI suite (style, security, tests)
```

### Database
```bash
bin/rails db:rollback        # Rollback last migration
bin/rails db:reset           # Drop, create, migrate, seed
bin/rails db:seed:replant    # Clear and re-seed database
```

## Application Configuration

### Locale & Timezone
- **Default Locale**: Russian (`:ru`)
- **Timezone**: Asia/Almaty
- Custom locale files are loaded from `my/locales/**/*.{rb,yml}` (configured in `config/application.rb:27`)

### Database Schema
The application currently has a single `tests` table:
- `id` (primary key)
- `title` (string, NOT NULL)
- `level` (integer)
- `created_at`, `updated_at` (timestamps)

### Models
- `Test` model exists at `app/models/test.rb` (minimal implementation, inherits from ApplicationRecord)

### Routes
Currently uses default Rails routes with health check endpoint at `/up`.

## CI/CD Pipeline

The `bin/ci` command runs the complete CI pipeline in this order:
1. Setup
2. Ruby style check (RuboCop)
3. Security: Gem audit, Importmap audit, Brakeman analysis
4. Tests: Rails tests, System tests
5. Test seed replanting

All CI steps must pass for code to be merge-ready.

## Code Style

Uses `rubocop-rails-omakase` for Ruby styling. Configuration in `.rubocop.yml`.

## Deployment

Configured for Kamal deployment (Docker-based). Deployment configuration in `config/deploy.yml`.
