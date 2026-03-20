#!/bin/bash

# Feedback Widget SaaS - Initialization Script
# This script sets up the entire project for development

echo "🚀 Initializing Feedback Widget SaaS Project"
echo "============================================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Setup backend
echo ""
echo "📦 Setting up Backend..."
cd backend

if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "✅ Created backend/.env from template"
    echo "⚠️  Please update the environment variables in backend/.env"
else
    echo "ℹ️  Backend .env already exists"
fi

if [ ! -d "node_modules" ]; then
    npm install
    echo "✅ Installed backend dependencies"
else
    echo "ℹ️  Backend dependencies already installed"
fi

cd ..

# Setup frontend widget
echo ""
echo "🎨 Setting up Frontend Widget..."
cd frontend

if [ ! -d "node_modules" ]; then
    npm install
    echo "✅ Installed frontend widget dependencies"
else
    echo "ℹ️  Frontend widget dependencies already installed"
fi

cd ..

# Setup landing page
echo ""
echo "🌐 Setting up Landing Page..."
cd landing

if [ ! -f ".env.local" ]; then
    cp .env.example .env.local
    echo "✅ Created landing/.env.local from template"
    echo "⚠️  Please update the environment variables in landing/.env.local"
else
    echo "ℹ️  Landing .env.local already exists"
fi

if [ ! -d "node_modules" ]; then
    npm install
    echo "✅ Installed landing page dependencies"
else
    echo "ℹ️  Landing page dependencies already installed"
fi

cd ..

# Build frontend widget
echo ""
echo "🔨 Building Frontend Widget..."
cd frontend
npm run build
echo "✅ Frontend widget built successfully"
cd ..

# Setup Docker environment
echo ""
echo "🐳 Setting up Docker Environment..."
if [ ! -d "mongodb_data" ]; then
    mkdir -p mongodb_data
    echo "✅ Created MongoDB data directory"
fi

echo ""
echo "🎯 Setup Complete!"
echo "=================="
echo ""
echo "Next steps:"
echo "1. Update environment variables in backend/.env and landing/.env.local"
echo "2. Start the development environment:"
echo "   docker-compose up -d"
echo "3. Start the landing page:"
echo "   cd landing && npm run dev"
echo "4. Open http://localhost:3000 in your browser"
echo ""
echo "For production deployment:"
echo "1. Set up MongoDB Atlas or production MongoDB"
echo "2. Configure Stripe accounts and webhooks"
echo "3. Deploy backend to Coolify"
echo "4. Deploy frontend to Cloudflare Pages"
echo "5. Deploy landing to Vercel/Netlify"
echo ""
echo "Happy coding! 🎉"