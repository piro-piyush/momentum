# Momentum

> Turn plans into progress.

Momentum is a simple, focused task management app built to help you turn plans into progress.
Node.js backend. It supports task scheduling, local storage,
authentication, and PostgreSQL persistence.
<p align="center">
  <img src="screenshots\banner.png" alt="Momentum" width="100%">
</p>
## Tech Stack

### Frontend

-   Flutter
-   Dart
-   Cubit / flutter_bloc
-   SQLite / sqflite

### Backend

-   Node.js
-   Express.js
-   PostgreSQL
-   Docker

## Project Structure

``` text
momentum/
├── frontend/              # Flutter application
│   ├── lib/
│   ├── assets/
│   └── ...
├── backend/               # Node.js + Express API
│   ├── src/
│   ├── Dockerfile
│   ├── compose.yaml
│   ├── nodemon.json
│   ├── tsconfig.json
│   └── ...
├── screenshots/            # App screenshots
│   ├── home.png
│   ├── login.png
│   ├── new_task.png
│   ├── profile.png
│   ├── register.png
│   ├── splash.png
│   ├── banner.png          # GitHub repository banner
│   └── update_task.png
└── README.md
```

## Screenshots

### Home

![Home](screenshots/home.png)

### Login

![Login](screenshots/login.png)

### Register

![Register](screenshots/register.png)

### New Task

![New Task](screenshots/new_task.png)

### Update Task

![Update Task](screenshots/update_task.png)

### Profile

![Profile](screenshots/profile.png)

### Splash

![Splash](screenshots/splash.png)

## Frontend

The Flutter app uses **Cubit** for state management and **sqflite** for
local task data.

``` text
Flutter
  ├── UI
  ├── Cubit
  ├── Repository
  └── SQLite (sqflite)
```

## Backend

The backend is built with **Node.js + Express** and uses **PostgreSQL**
as the database.

``` text
Flutter App
     │
     ▼
Express REST API
     │
     ▼
PostgreSQL
```

## Docker

The backend and PostgreSQL database can be run using Docker / Docker
Compose.

``` bash
docker compose up --build
```

Stop containers:

``` bash
docker compose down
```

## Running Locally

### Frontend

``` bash
cd frontend
flutter pub get
flutter run
```

### Backend

``` bash
cd backend
npm install
npm run dev
```

### PostgreSQL

Configure the PostgreSQL connection in the backend `.env` file.

Example:

``` env
NODE_ENV=development
PORT=8000

POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=momentum_app
POSTGRES_PASSWORD=your_password
POSTGRES_DB=momentum

JWT_SECRET=your_jwt_secret
LOG_LEVEL=info

RESEND_API_KEY=re_xxxxxxxxx
MAIL_FROM=Momentum <onboarding@resend.dev>
FRONTEND_URL=http://localhost:3000
```

## Features

-   User authentication
-   Create tasks
-   Update tasks
-   Delete tasks
-   Schedule tasks
-   View daily tasks
-   Task statistics
-   Local SQLite storage
-   PostgreSQL backend
-   REST API
-   Docker support

## API

The backend exposes REST APIs for authentication and task management.

``` text
/api/auth
/api/tasks
```

## License

This project is for learning and personal use.
