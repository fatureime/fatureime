#!/bin/bash

echo "🔍 Verifying Invoicing App Setup..."
echo ""

# Check if Docker is running
echo "1. Checking Docker..."
if ! docker info > /dev/null 2>&1; then
    echo "   ❌ Docker is not running. Please start Docker."
    exit 1
fi
echo "   ✅ Docker is running"

# Check if docker-compose is available
echo "2. Checking Docker Compose..."
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "   ❌ Docker Compose is not installed."
    exit 1
fi
echo "   ✅ Docker Compose is available"

# Check if required directories exist
echo "3. Checking project structure..."
if [ ! -d "backend" ]; then
    echo "   ❌ Backend directory not found"
    exit 1
fi
if [ ! -d "frontend" ]; then
    echo "   ❌ Frontend directory not found"
    exit 1
fi
echo "   ✅ Project structure looks good"

# Check if backend has required files
echo "4. Checking backend files..."
if [ ! -f "backend/composer.json" ]; then
    echo "   ❌ backend/composer.json not found"
    exit 1
fi
if [ ! -f "backend/Dockerfile" ]; then
    echo "   ❌ backend/Dockerfile not found"
    exit 1
fi
echo "   ✅ Backend files present"

# Check if frontend has required files
echo "5. Checking frontend files..."
if [ ! -f "frontend/package.json" ]; then
    echo "   ❌ frontend/package.json not found"
    exit 1
fi
if [ ! -f "frontend/Dockerfile" ]; then
    echo "   ❌ frontend/Dockerfile not found"
    exit 1
fi
if [ ! -f "frontend/tsconfig.json" ]; then
    echo "   ❌ frontend/tsconfig.json not found (TypeScript config)"
    exit 1
fi
echo "   ✅ Frontend files present"

# Check Docker Compose files
echo "6. Checking Docker Compose files..."
if [ ! -f "docker-compose.dev.yml" ]; then
    echo "   ❌ docker-compose.dev.yml not found"
    exit 1
fi
if [ ! -f "docker-compose.prod.yml" ]; then
    echo "   ❌ docker-compose.prod.yml not found"
    exit 1
fi
echo "   ✅ Docker Compose files present"

echo ""
echo "✅ All checks passed! Setup looks good."
echo ""
echo "Next steps:"
echo "1. Build and start the development environment:"
echo "   docker-compose -f docker-compose.dev.yml up -d --build"
echo ""
echo "2. Install backend dependencies:"
echo "   docker-compose -f docker-compose.dev.yml exec backend composer install"
echo ""
echo "3. Install frontend dependencies:"
echo "   docker-compose -f docker-compose.dev.yml exec frontend npm install"
echo ""
echo "4. Access the application:"
echo "   Frontend: http://localhost:80 or http://localhost:3000"
echo "   Backend API: http://localhost:80/api"
