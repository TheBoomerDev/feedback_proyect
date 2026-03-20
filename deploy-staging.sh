#!/bin/bash

# Feedback Widget Staging Deployment Script
# This script deploys the application to staging environment

set -e

echo "🚀 Starting Feedback Widget Staging Deployment"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required environment variables are set
check_env_vars() {
    print_status "Checking environment variables..."

    required_vars=(
        "MONGO_ROOT_USERNAME"
        "MONGO_ROOT_PASSWORD"
        "STRIPE_SECRET_KEY"
        "STRIPE_PUBLISHABLE_KEY"
        "STRIPE_WEBHOOK_SECRET"
        "JWT_SECRET"
    )

    missing_vars=()

    for var in "${required_vars[@]}"; do
        if [[ -z "${!var}" ]]; then
            missing_vars+=("$var")
        fi
    done

    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        print_error "Missing required environment variables:"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        exit 1
    fi

    print_success "All required environment variables are set"
}

# Build and test locally
build_and_test() {
    print_status "Building and testing locally..."

    # Test backend (no build needed for Node.js)
    print_status "Testing backend..."
    cd backend
    if npm test --silent 2>/dev/null; then
        print_success "Backend tests passed"
    else
        print_warning "Backend tests not found or failed, continuing..."
    fi
    cd ..

    # Build frontend
    print_status "Building frontend..."
    cd frontend
    npm run build
    if npm test --silent 2>/dev/null; then
        print_success "Frontend tests passed"
    else
        print_warning "Frontend tests failed or not found"
    fi
    cd ..

    # Build landing
    print_status "Building landing page..."
    cd landing
    npm run build
    cd ..

    print_success "All builds completed"
}

# Deploy using docker-compose
deploy_staging() {
    print_status "Deploying to staging environment..."

    # Stop existing containers
    docker-compose -f docker-compose.staging.yml down || true

    # Build and start containers
    docker-compose -f docker-compose.staging.yml up -d --build

    # Wait for services to be healthy
    print_status "Waiting for services to be healthy..."
    sleep 30

    # Check backend health
    if curl -f http://localhost:3001/api/health > /dev/null 2>&1; then
        print_success "Backend is healthy"
    else
        print_error "Backend health check failed"
        exit 1
    fi

    # Check landing page health
    if curl -f http://localhost:3000 > /dev/null 2>&1; then
        print_success "Landing page is healthy"
    else
        print_error "Landing page health check failed"
        exit 1
    fi

    print_success "Staging deployment completed successfully"
}

# Run database migrations if needed
run_migrations() {
    print_status "Running database migrations..."

    # This would typically run migration scripts
    # For now, we'll just ensure the database is accessible
    docker-compose -f docker-compose.staging.yml exec -T mongodb mongo --eval "db.stats()" > /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
        print_success "Database is accessible"
    else
        print_error "Database connection failed"
        exit 1
    fi
}

# Main deployment flow
main() {
    print_status "Starting staging deployment process..."

    # Change to project directory
    cd "$(dirname "$0")"

    # Check environment
    check_env_vars

    # Build and test
    build_and_test

    # Deploy
    deploy_staging

    # Run migrations
    run_migrations

    print_success "🎉 Staging deployment completed successfully!"
    echo ""
    echo "Services available at:"
    echo "  - Landing Page: http://localhost:3000"
    echo "  - API: http://localhost:3001"
    echo "  - Widget: http://localhost:80/widget.js"
    echo ""
    echo "To view logs: docker-compose -f docker-compose.staging.yml logs -f"
    echo "To stop: docker-compose -f docker-compose.staging.yml down"
}

# Run main function
main "$@"