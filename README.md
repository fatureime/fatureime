# Invoicing App

Multi-repository invoicing application with Symfony backend and React frontend.

## Technology Stack

- **Backend**: Symfony 8.0.3, PHP 8.4, Composer 2.9.3
- **Frontend**: React 19.2 with TypeScript (Vite)
- **Database**: PostgreSQL 18.1
- **Containerization**: Docker & Docker Compose

## Repository Structure

This project consists of three repositories:

- **Parent Repository** (`fatureime/`): Contains Docker Compose configurations and workspace settings
- **Backend** (`backend/`): Symfony application (git submodule)
- **Frontend** (`frontend/`): React application (git submodule)

## Prerequisites

- Docker and Docker Compose
- Git
- VS Code (for debugging)

## Initial Setup

### 1. Clone the repository

```bash
git clone <repository-url> fatureime
cd fatureime
```

### 2. Initialize and update submodules

```bash
git submodule init
git submodule update
```

Or clone with submodules:

```bash
git clone --recurse-submodules <repository-url> fatureime
```

### 3. Development Environment

Start the development environment:

```bash
docker-compose -f docker-compose.dev.yml up -d --build
```

This will start:
- Symfony backend on `http://localhost:80/api` (via main nginx)
- React frontend on `http://localhost:80` (via main nginx) or `http://localhost:3000` (direct)
- PostgreSQL database on port `5432`

### 4. Backend Setup

Install dependencies inside the container:

```bash
docker-compose -f docker-compose.dev.yml exec backend composer install
```

**Sync vendor for VS Code**: To enable stepping into vendor files in VS Code, copy the vendor directory from the container:

```bash
docker cp invoicing_backend:/var/www/html/vendor ./backend
```

### 5. Frontend Setup

Install dependencies inside the container:

```bash
docker-compose -f docker-compose.dev.yml exec frontend npm install
```

### 6. Environment Configuration

#### Backend Environment Setup

1. Copy the example environment file:
```bash
cd backend
cp .env.example .env
```

2. Update the `.env` file with your values:
   - `APP_ENV`: Set to `dev` for development or `prod` for production
   - `APP_SECRET`: Generate a strong random secret (e.g., `openssl rand -hex 32`)
   - `DATABASE_URL`: Update with your database credentials

#### Frontend Environment Setup

1. Copy the example environment file:
```bash
cd frontend
cp .env.example .env
```

2. Update the `.env` file with your production API URL:
   - `VITE_API_URL`: Your backend API URL (e.g., `http://localhost:8000` for dev)

## Development

### Running in Development Mode

```bash
docker-compose -f docker-compose.dev.yml up
```

### Stopping Services

```bash
docker-compose -f docker-compose.dev.yml down
```

### Viewing Logs

```bash
# All services
docker-compose -f docker-compose.dev.yml logs -f

# Specific service
docker-compose -f docker-compose.dev.yml logs -f backend
docker-compose -f docker-compose.dev.yml logs -f frontend
```

### Accessing Services

- **Frontend**: http://localhost:80 or http://localhost:3000
- **Backend API**: http://localhost:80/api
- **PostgreSQL**: localhost:5432

## Production

### Deployment Steps

1. **Set up environment files**:
```bash
# Backend
cd backend
cp .env.example .env
# Edit .env with production values

# Frontend
cd frontend
cp .env.example .env
# Edit .env with production API URL
```

2. **Set environment variables** (or use a `.env` file in the root):
```bash
export POSTGRES_PASSWORD=your-secure-password
export APP_SECRET=your-generated-secret
```

3. **Build and run production environment**:
```bash
docker-compose -f docker-compose.prod.yml up -d --build
```

**Important**: Before running in production:
- Update `POSTGRES_PASSWORD` environment variable
- Update `APP_SECRET` in `backend/.env`
- Update `DATABASE_URL` in `backend/.env` with production database credentials
- Update `VITE_API_URL` in `frontend/.env` with production API URL

## Debugging

### Backend (PHP/Xdebug)

1. Ensure Xdebug is enabled in the PHP container
2. Use VS Code debugger with the "Listen for Xdebug" configuration
3. Set breakpoints in your PHP code
4. Make a request to trigger the breakpoint

### Frontend (React/Chrome DevTools)

1. Use VS Code debugger with the "Launch Chrome" configuration
2. Set breakpoints in your TypeScript/React code
3. The debugger will attach to Chrome automatically

## Database

PostgreSQL is available at:
- **Host**: `localhost` (from host) or `postgres` (from containers)
- **Port**: `5432`
- **Default Database**: `invoicing`
- **User**: `postgres`
- **Password**: `postgres` (change in production!)

### Database Commands

```bash
# Access PostgreSQL CLI
docker-compose -f docker-compose.dev.yml exec postgres psql -U postgres -d invoicing

# Run migrations (after composer install)
docker-compose -f docker-compose.dev.yml exec backend php bin/console doctrine:migrations:migrate
```

## Project Structure

```
fatureime/
├── backend/          # Symfony application (submodule)
│   ├── config/       # Symfony configuration
│   ├── public/       # Web root
│   ├── src/          # Application source code
│   └── ...
├── frontend/         # React application (submodule)
│   ├── src/          # React source code (TypeScript)
│   ├── public/       # Static assets
│   └── ...
├── docker-compose.dev.yml
├── docker-compose.prod.yml
└── .vscode/          # VS Code workspace settings
```

## Troubleshooting

### Backend not responding

1. Check if PHP-FPM is running: `docker-compose -f docker-compose.dev.yml ps`
2. Check backend logs: `docker-compose -f docker-compose.dev.yml logs backend`
3. Ensure composer dependencies are installed
4. Check nginx configuration

### Frontend not loading

1. Check if Node container is running
2. Check frontend logs: `docker-compose -f docker-compose.dev.yml logs frontend`
3. Ensure npm dependencies are installed
4. Check if port 3000 is available

### Database connection issues

1. Verify PostgreSQL is running: `docker-compose -f docker-compose.dev.yml ps postgres`
2. Check database logs: `docker-compose -f docker-compose.dev.yml logs postgres`
3. Verify DATABASE_URL in backend/.env matches the container setup

## Contributing

1. Work in the respective submodule repositories
2. Commit changes in each submodule
3. Update the parent repository to point to the new submodule commits

## License

[Your License Here]
