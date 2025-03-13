# Project Management API

A RESTful API for managing projects and tasks. This API allows users to create, update, delete, and retrieve projects and tasks with support for filtering tasks by status.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [API Endpoints](#api-endpoints)
  - [Users](#users)
  - [Projects](#projects)
  - [Tasks](#tasks)
- [Caching](#caching)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Features

- CRUD operations for Projects and Tasks.
- Task filtering by status.
- Optimized database queries with `includes`, `select`, and `where`.
- Caching frequently used queries for improved performance.
- User authentication via token-based system.
 
## Installation

### Prerequisites

- Ruby 3.0 or higher
- Rails 6 or higher
- PostgreSQL
- Yarn

 
### Steps

1. Clone the repository:

```bash
git clone https://github.com/Jerry806/management_system_project.git
cd management_system_project
```
2. Install the required gems:
```bash
bundle install
```
3. Set up JS dependencies:
```bash
yarn install
```
4. Create an environment configuration file:\
Edit the .env to suit your environment (specify variables for connecting to the database).
```bash
cp .env.example .env
```
5. Setup the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```
6. Start the server:
```bash
rails server
```
The API will be available at [http://localhost:3000](http://localhost:3000).


## Configuration

### Authentication
This API uses token-based authentication via the authentication_token for each user. The token is required for all requests that involve project or task management.

## API Endpoints
### Users
- POST /register\
  Creates a new user.
```bash
curl -X POST "http://localhost:3000/register"
-d '{
  "user": {
    "email": "your_email@example.com",
    "password": "password"
  }
}'
```
- POST /login\
  To authenticate the user and receive a token for further work with the API.
```bash
curl -X POST "http://localhost:3000/login"
-d '{
  "user": {
    "email": "your_email@example.com",
    "password": "password"
  }
}'
```
### Projects
- GET /projects\
  Returns a list of all projects.

  - Query parameter:\
    task_status (optional): Filter projects based on task status.\
    with_tasks (optional): Returns projects with nested tasks.
```bash
curl -X GET "http://localhost:3000/projects"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
```

- GET /projects/:id\
  Returns a specific project by its ID.

  - Query parameter:\
    task_status (optional): Filters tasks by status.
```bash
curl -X GET "http://localhost:3000/projects/:id"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
```

- POST /projects\
  Creates a new project.
```bash
curl -X POST "http://localhost:3000/projects"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
-d '{
  "name": "New Project",
  "description": "Project description"
}'
```

- PUT /projects/:id\
  Updates an existing project.
```bash
curl -X PUT "http://localhost:3000/projects/:id"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
-d '{
  "name": "Updated Project",
  "description": "Updated description"
}'
```

- DELETE /projects/:id\
  Deletes a project.
```bash
curl -X DELETE "http://localhost:3000/projects/:id"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
```

### Tasks
- GET /projects/:project_id/tasks\
  Returns a list of tasks by project ID.

  - Query parameter:\
    status (optional): Filters tasks by status.
```bash
curl -X GET "http://localhost:3000/projects/:id/tasks"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
```

- GET /projects/:project_id/tasks/:id\
  Returns a specific task by project ID.
```bash
curl -X GET "http://localhost:3000/projects/:id/tasks/:id"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
```

- POST /projects/:project_id/tasks\
  Creates a new task.\
  The status parameter is optional.
```bash
curl -X POST "http://localhost:3000/projects/:project_id/tasks"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
-d '{
  "name": "New Task",
  "link": "Tasks link",
  "description": "Tasks description",
  "status": "new_task"
}'
```

- PUT /projects/:project_id/tasks/:id\
  Updates an existing task.
```bash
curl -X POST "http://localhost:3000/projects/:project_id/tasks"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
-d '{
  "status": "completed"
}'
```

- DELETE /projects/:project_id/tasks/:id\
  Deletes a task.
```bash
curl -X DELETE "http://localhost:3000/projects/:project_id/tasks/:id"
-H "X-User-Token: YOUR_TOKEN"
-H "X-User-Email: YOUR_EMAIL"
```

## Caching
This API employs caching for frequently accessed project and task data.\
The cache is cleared whenever a project or task is created, updated, or deleted.


## Testing
Unit Tests
Unit tests are written using RSpec. You can run them with:

```bash
bundle exec rspec
```

## Contributing
1. Fork the repository.
2. Create a new branch (git checkout -b feature-name).
3. Make your changes and write tests.
4. Commit your changes (git commit -am 'Add new feature').
5. Push to your fork (git push origin feature-name).
6. Create a new Pull Request.

## License

[MIT](https://choosealicense.com/licenses/mit/)