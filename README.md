# 📚 BookVault

> A cross-platform personal book tracking app — secured per user, built with Flutter and Ruby on Rails.

Users can register, log in, and privately manage their own book collection. Every user sees only their own books. Authentication is handled using JWT tokens and passwords are encrypted with bcrypt.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Mobile Frontend | Flutter (Dart) |
| Backend API | Ruby on Rails 8 (API mode) |
| Database | PostgreSQL |
| Authentication | JWT (JSON Web Token) |
| Password Security | bcrypt (has_secure_password) |

---

## 📁 Project Structure

```
BookVaultProject/
│
├── auth_backend/                   # Rails API Backend
│   ├── app/
│   │   ├── controllers/
│   │   │   ├── application_controller.rb
│   │   │   ├── auth_controller.rb      # signup, login
│   │   │   └── books_controller.rb     # CRUD for books
│   │   └── models/
│   │       ├── user.rb
│   │       └── book.rb
│   ├── db/
│   │   ├── migrate/
│   │   │   ├── 20260516150701_create_users.rb
│   │   │   └── 20260516150738_create_books.rb
│   │   └── schema.rb
│   └── config/
│       └── routes.rb
│
└── flutter_frontend/               # Flutter Mobile App
    └── lib/
        ├── main.dart               # App entry point
        ├── screens/
        │   ├── login_screen.dart
        │   ├── signup_screen.dart
        │   └── home_screen.dart
        └── services/
            └── api_service.dart    # All HTTP calls
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App                          │
│                                                         │
│   LoginScreen ──► HomeScreen ──► showAddBookDialog      │
│   SignupScreen          │                               │
│                         ▼                               │
│                   ApiService                            │
│              (lib/services/api_service.dart)            │
└─────────────────────────┬───────────────────────────────┘
                          │
                HTTP REST API Calls
                (JSON over HTTP)
                          │
┌─────────────────────────▼───────────────────────────────┐
│                 Ruby on Rails API                       │
│                  localhost:3000                         │
│                                                         │
│   POST /signup  ──► AuthController#signup               │
│   POST /login   ──► AuthController#login                │
│   GET  /books   ──► BooksController#index               │
│   POST /books   ──► BooksController#create              │
│   DELETE /books/:id ► BooksController#destroy           │
└─────────────────────────┬───────────────────────────────┘
                          │
                    ActiveRecord ORM
                          │
┌─────────────────────────▼───────────────────────────────┐
│                    PostgreSQL                           │
│                                                         │
│    users ──────────────── books                         │
│    (id, name, email,      (id, title, author,           │
│     password_digest)       description, user_id)        │
└─────────────────────────────────────────────────────────┘
```

---

## 🔄 Application Flow

### Signup Flow
```
User fills Signup form
        │
        ▼
Flutter calls POST /signup
        │
        ▼
Rails creates User (bcrypt hashes password)
        │
        ▼
Rails returns JWT token
        │
        ▼
Flutter saves token in SharedPreferences
        │
        ▼
User lands on HomeScreen
```

### Login Flow
```
User fills Login form
        │
        ▼
Flutter calls POST /login
        │
        ▼
Rails finds user by email → verifies password
        │
        ▼
Rails returns JWT token
        │
        ▼
Flutter saves token → HomeScreen
```

### Authenticated Request Flow (Books)
```
Flutter reads token from SharedPreferences
        │
        ▼
Sends request with header: Authorization: Bearer <token>
        │
        ▼
Rails decodes JWT → finds current_user
        │
        ▼
Returns only that user's books
```

---

## 🗄️ Database Structure

### Table: `users`

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | bigint | PRIMARY KEY | Auto-generated |
| name | string | NOT NULL | Display name |
| email | string | NOT NULL, UNIQUE | Used for login |
| password_digest | string | NOT NULL | bcrypt hash |
| created_at | datetime | NOT NULL | Auto-managed by Rails |
| updated_at | datetime | NOT NULL | Auto-managed by Rails |

### Table: `books`

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | bigint | PRIMARY KEY | Auto-generated |
| user_id | bigint | NOT NULL, FOREIGN KEY | Owner of the book |
| title | string | NOT NULL | Book title |
| author | string | | Author name |
| description | text | | Long description |
| created_at | datetime | NOT NULL | Auto-managed by Rails |
| updated_at | datetime | NOT NULL | Auto-managed by Rails |

### Relationship

```
users                          books
──────────────────             ─────────────────────────
id (PK)        ◄────────────── user_id (FK)
name                           id (PK)
email                          title
password_digest                author
created_at                     description
updated_at                     created_at
                               updated_at

One user → Many books
One book → Belongs to one user
Deleting a user → Deletes all their books (dependent: :destroy)
```

---

## 🧮 SQL Queries

### Create Tables

```sql
CREATE TABLE users (
  id               BIGSERIAL PRIMARY KEY,
  name             VARCHAR(255),
  email            VARCHAR(255) UNIQUE,
  password_digest  VARCHAR(255),
  created_at       TIMESTAMP NOT NULL,
  updated_at       TIMESTAMP NOT NULL
);

CREATE TABLE books (
  id           BIGSERIAL PRIMARY KEY,
  user_id      BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title        VARCHAR(255),
  author       VARCHAR(255),
  description  TEXT,
  created_at   TIMESTAMP NOT NULL,
  updated_at   TIMESTAMP NOT NULL
);

CREATE INDEX index_books_on_user_id ON books (user_id);
CREATE UNIQUE INDEX index_users_on_email ON users (email);
```

---

### Insert Dummy Data

```sql
-- Users (password_digest is bcrypt hash of "password123")
INSERT INTO users (name, email, password_digest, created_at, updated_at)
VALUES
  ('Arjun Sharma',  'arjun@example.com',  '$2a$12$KIXBp0N9QvmOq6XxGpZ4aOQRm5PkXeM0Y1sGJhV4w3tZ7dNcRe8Hy', NOW(), NOW()),
  ('Priya Mehta',   'priya@example.com',  '$2a$12$LJYCq1O0RwnPr7YyHqA5bPRSn6QlYfN1Z2tHKiW5x4uA8eOdSf9Iz', NOW(), NOW()),
  ('Rohan Verma',   'rohan@example.com',  '$2a$12$MKZDr2P1SxoQs8ZzIrB6cQSTn7RmZgO2A3uILjX6y5vB9fPeSg0Ja', NOW(), NOW()),
  ('Sneha Patil',   'sneha@example.com',  '$2a$12$NLAEs3Q2TypRt9AaJsC7dRTUo8SnAhP3B4vJMkY7z6wC0gQfTh1Kb', NOW(), NOW()),
  ('Dev Nair',      'dev@example.com',    '$2a$12$OMBFt4R3UzqSu0BbKtD8eSTVp9ToBindC5wKNlZ8A7xD1hRgUi2Lc', NOW(), NOW());
```

```sql
-- Books for Arjun (user_id = 1)
INSERT INTO books (user_id, title, author, description, created_at, updated_at)
VALUES
  (1, 'Atomic Habits',         'James Clear',       'A guide to building good habits and breaking bad ones through small changes.', NOW(), NOW()),
  (1, 'The Psychology of Money','Morgan Housel',     'Timeless lessons on wealth, greed, and happiness.', NOW(), NOW()),
  (1, 'Deep Work',             'Cal Newport',        'Rules for focused success in a distracted world.', NOW(), NOW());

-- Books for Priya (user_id = 2)
INSERT INTO books (user_id, title, author, description, created_at, updated_at)
VALUES
  (2, 'The Alchemist',         'Paulo Coelho',       'A philosophical novel about following your dreams.', NOW(), NOW()),
  (2, 'Ikigai',                'Hector Garcia',      'The Japanese secret to a long and happy life.', NOW(), NOW());

-- Books for Rohan (user_id = 3)
INSERT INTO books (user_id, title, author, description, created_at, updated_at)
VALUES
  (3, 'Rich Dad Poor Dad',     'Robert Kiyosaki',    'What the rich teach their kids about money.', NOW(), NOW()),
  (3, 'Zero to One',           'Peter Thiel',        'Notes on startups and how to build the future.', NOW(), NOW()),
  (3, 'The Lean Startup',      'Eric Ries',          'How constant innovation creates radically successful businesses.', NOW(), NOW());

-- Books for Sneha (user_id = 4)
INSERT INTO books (user_id, title, author, description, created_at, updated_at)
VALUES
  (4, 'Sapiens',               'Yuval Noah Harari',  'A brief history of humankind.', NOW(), NOW()),
  (4, 'Educated',              'Tara Westover',      'A memoir about self-invention and the power of education.', NOW(), NOW());

-- Books for Dev (user_id = 5)
INSERT INTO books (user_id, title, author, description, created_at, updated_at)
VALUES
  (5, 'Clean Code',            'Robert C. Martin',   'A handbook of agile software craftsmanship.', NOW(), NOW()),
  (5, 'The Pragmatic Programmer','David Thomas',     'From journeyman to master — timeless software wisdom.', NOW(), NOW());
```

---

### Common Queries

```sql
-- Get all users
SELECT id, name, email, created_at FROM users;

-- Get all books with their owner's name
SELECT
  books.id,
  books.title,
  books.author,
  books.description,
  users.name AS owner_name,
  users.email AS owner_email
FROM books
JOIN users ON books.user_id = users.id
ORDER BY users.name, books.title;

-- Get all books belonging to a specific user
SELECT * FROM books WHERE user_id = 1;

-- Count books per user
SELECT
  users.name,
  users.email,
  COUNT(books.id) AS total_books
FROM users
LEFT JOIN books ON books.user_id = users.id
GROUP BY users.id, users.name, users.email
ORDER BY total_books DESC;

-- Search books by title (case-insensitive)
SELECT * FROM books WHERE LOWER(title) LIKE LOWER('%habit%');

-- Search books by author
SELECT * FROM books WHERE LOWER(author) LIKE LOWER('%clear%');

-- Get most recently added books
SELECT books.title, books.author, users.name AS added_by, books.created_at
FROM books
JOIN users ON books.user_id = users.id
ORDER BY books.created_at DESC
LIMIT 5;

-- Delete a specific book
DELETE FROM books WHERE id = 3 AND user_id = 1;

-- Delete all books for a user
DELETE FROM books WHERE user_id = 2;

-- Update a book's description
UPDATE books
SET description = 'Updated description here.', updated_at = NOW()
WHERE id = 1 AND user_id = 1;
```

---

## 🔐 API Reference

### Auth Endpoints

#### POST `/signup`

Request:
```json
{
  "name": "Arjun Sharma",
  "email": "arjun@example.com",
  "password": "password123"
}
```

Response `201 Created`:
```json
{
  "user": {
    "id": 1,
    "name": "Arjun Sharma",
    "email": "arjun@example.com"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

---

#### POST `/login`

Request:
```json
{
  "email": "arjun@example.com",
  "password": "password123"
}
```

Response `200 OK`:
```json
{
  "user": {
    "id": 1,
    "name": "Arjun Sharma",
    "email": "arjun@example.com"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

---

### Book Endpoints

> All book endpoints require the header:
> `Authorization: Bearer <your_token>`

#### GET `/books`

Response `200 OK`:
```json
[
  {
    "id": 1,
    "title": "Atomic Habits",
    "author": "James Clear",
    "description": "A guide to building good habits.",
    "user_id": 1,
    "created_at": "2026-05-18T10:00:00.000Z",
    "updated_at": "2026-05-18T10:00:00.000Z"
  }
]
```

---

#### POST `/books`

Request:
```json
{
  "title": "Deep Work",
  "author": "Cal Newport",
  "description": "Rules for focused success in a distracted world."
}
```

Response `201 Created`:
```json
{
  "id": 2,
  "title": "Deep Work",
  "author": "Cal Newport",
  "description": "Rules for focused success in a distracted world.",
  "user_id": 1
}
```

---

#### DELETE `/books/:id`

Response `200 OK`:
```json
{
  "message": "Book deleted"
}
```

---

## ⚙️ Setup & Running

### Prerequisites

| Tool | Check |
|---|---|
| Ruby | `ruby -v` |
| Rails | `rails -v` |
| PostgreSQL | `psql --version` |
| Flutter | `flutter --version` |
| Git | `git --version` |

---

### Backend Setup (Rails)

```bash
# 1. Go to backend folder
cd BookVaultProject/auth_backend

# 2. Install gems
bundle install

# 3. Start PostgreSQL
# Mac:
brew services start postgresql
# Linux:
sudo service postgresql start

# 4. Create and migrate database
rails db:create
rails db:migrate

# 5. (Optional) Load dummy data
rails db:seed

# 6. Start server
rails server
```

Backend runs at: `http://127.0.0.1:3000`

---

### Flutter Setup

```bash
# 1. Go to Flutter folder
cd BookVaultProject/flutter_frontend

# 2. Install packages
flutter pub get

# 3. Check available devices
flutter devices

# 4. Run the app
flutter run

# For Chrome
flutter run -d chrome
```

> **Android Emulator Note:** Change `baseUrl` in `api_service.dart` from
> `http://127.0.0.1:3000` to `http://10.0.2.2:3000`

---

## 🚀 GitHub Setup

```bash
# Inside BookVaultProject folder:

# Remove nested git (if any)
Remove-Item -Recurse -Force .\auth_backend\.git   # Windows
rm -rf auth_backend/.git                          # Mac/Linux

git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/BookVaultProject.git
git push -u origin main
```

---

## 🛡️ Security

- Passwords are never stored as plain text — bcrypt hashes them automatically via `has_secure_password`
- JWT tokens expire per request scope — no token = no data access
- Every book query is scoped to `@current_user` — users cannot access each other's books
- Rails strong parameters prevent mass assignment attacks

---

## 💡 Future Improvements

- [ ] Book categories and tags
- [ ] Search and filter books
- [ ] Pagination
- [ ] Book cover image upload
- [ ] Reading status (want to read / reading / finished)
- [ ] Star ratings and personal notes
- [ ] Dark mode in Flutter
- [ ] Docker support
- [ ] CI/CD pipeline

---

## 👨‍💻 Author

Built as a full-stack learning project demonstrating Flutter + Rails + PostgreSQL + JWT integration.
