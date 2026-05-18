# 📚 BookVault

BookVault is a full-stack mobile book management application built using Flutter, Ruby on Rails API, MySQL, and JWT Authentication.

The application allows users to securely register, log in, and manage their personal collection of books through CRUD operations.

---

# 🚀 Features

## 🔐 Authentication
- User Signup
- User Login
- JWT Authentication
- Secure Password Encryption using bcrypt
- Logout functionality

## 📚 Book Management
- Add Books
- View Books
- Update Books
- Delete Books
- User-specific books

---

# 🛠️ Tech Stack

## Frontend
- Flutter

## Backend
- Ruby on Rails API

## Database
- MySQL

## Authentication
- JWT (JSON Web Token)

---

# 📁 Project Structure

```text
BookVault/
│
├── auth_backend/      # Rails API Backend
│
└── flutter_app/       # Flutter Frontend
```

---

# 🔄 Application Flow

```text
Flutter App
     ↓
HTTP API Requests
     ↓
Ruby on Rails Backend
     ↓
MySQL Database
     ↓
JWT Token Response
     ↓
Authenticated User Session
```

---

# 📚 Use Case

BookVault is designed as a secure personal book management platform.

Users can:
- Create accounts
- Authenticate securely
- Maintain their own collection of books
- Perform CRUD operations on books

This project demonstrates complete frontend-backend integration using REST APIs and token-based authentication.

---

# ⚙️ Backend Setup (Rails API)

## Step 1 — Navigate to Backend

```bash
cd auth_backend
```

---

## Step 2 — Install Gems

```bash
bundle install
```

---

## Step 3 — Configure Database

Open:

```text
config/database.yml
```

Update password:

```yml
password: root123
```

Replace with your MySQL password.

---

## Step 4 — Create Database

```bash
rails db:create
```

---

## Step 5 — Run Migrations

```bash
rails db:migrate
```

---

## Step 6 — Start Rails Server

```bash
rails s
```

Backend runs on:

```text
http://localhost:3000
```

---

# 📱 Flutter Setup

## Step 1 — Navigate to Flutter Project

```bash
cd flutter_app
```

---

## Step 2 — Install Packages

```bash
flutter pub get
```

---

## Step 3 — Run Flutter App

```bash
flutter run
```

---

# 📌 Important Emulator Note

For Android emulator use:

```text
http://10.0.2.2:3000
```

instead of:

```text
localhost
```

because Android emulator cannot directly access localhost.

---

# 🔐 Authentication APIs

## Signup API

### Endpoint

```text
POST /signup
```

### Request Body

```json
{
  "name": "Mavin",
  "email": "mavin@test.com",
  "password": "123456"
}
```

---

## Login API

### Endpoint

```text
POST /login
```

### Request Body

```json
{
  "email": "mavin@test.com",
  "password": "123456"
}
```

---

# 📚 Book APIs

## Get All Books

```text
GET /books
```

---

## Add Book

```text
POST /books
```

### Request Body

```json
{
  "title": "Atomic Habits",
  "author": "James Clear",
  "description": "Self improvement book"
}
```

---

## Update Book

```text
PUT /books/:id
```

---

## Delete Book

```text
DELETE /books/:id
```

---

# 🛡️ Security Features

- JWT Authentication
- Password Hashing using bcrypt
- Protected APIs
- User-specific data access
- Rails strong parameters

---

# 📂 Recommended Flutter Structure

```text
lib/
├── screens/
├── services/
├── models/
├── widgets/
├── utils/
```

---

# 📂 Recommended Rails Structure

```text
app/
├── controllers/
├── models/
├── lib/
├── services/
```

---

# 🧪 Dummy SQL Data

## Users Table Dummy Data

```sql
INSERT INTO users (id, name, email, password_digest, created_at, updated_at)
VALUES
(1, 'Mavin', 'mavin@test.com', '$2a$12$abcdefghijklmnopqrstuv', NOW(), NOW()),
(2, 'John', 'john@test.com', '$2a$12$abcdefghijklmnopqrstuv', NOW(), NOW());
```

---

## Books Table Dummy Data

```sql
INSERT INTO books (title, author, description, user_id, created_at, updated_at)
VALUES
('Atomic Habits', 'James Clear', 'Self improvement book', 1, NOW(), NOW()),
('Rich Dad Poor Dad', 'Robert Kiyosaki', 'Finance and mindset book', 1, NOW(), NOW()),
('The Alchemist', 'Paulo Coelho', 'Inspirational novel', 2, NOW(), NOW());
```

---

# 🌐 GitHub Setup

## Initialize Git

```bash
git init
```

---

## Add Files

```bash
git add .
```

---

## Commit Code

```bash
git commit -m "Initial Commit"
```

---

## Add GitHub Repository

```bash
git remote add origin YOUR_REPOSITORY_URL
```

---

## Push Code

```bash
git branch -M main
git push -u origin main
```

---

# 🧪 API Testing Tools

You can test APIs using:
- Postman
- Thunder Client
- Flutter Frontend

---

# 💡 Future Improvements

- Search books
- Pagination
- Categories
- Book cover upload
- Docker support
- CI/CD pipeline
- Admin dashboard
- Dark mode

---

# 🎯 Interview Highlights

This project demonstrates:
- Full-stack development
- REST API development
- JWT authentication
- CRUD operations
- Mobile-backend integration
- Database relationships
- MVC architecture
- Secure authentication flow

---

# 👨‍💻 Author

Mavin