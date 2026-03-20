#!/bin/bash

# Production Deployment Script for Feedback Widget SaaS
# Deploys to Coolify + Cloudflare Pages + Vercel

set -e

echo "🚀 Starting Production Deployment"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check required environment variables
check_production_env() {
    print_status "Checking production environment variables..."

    required_vars=(
        "PRODUCTION_DOMAIN"
        "COOLIFY_API_KEY"
        "CLOUDFLARE_API_TOKEN"
        "VERCEL_TOKEN"
        "MONGODB_ATLAS_URI"
        "STRIPE_SECRET_KEY"
        "STRIPE_PUBLISHABLE_KEY"
        "JWT_SECRET"
    )

    missing_vars=()

    for var in "${required_vars[@]}"; do
        if [[ -z "${!var}" ]]; then
            missing_vars+=("$var")
        fi
    done

    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        print_error "Missing required production environment variables:"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        print_warning "Please set these variables before running production deployment"
        exit 1
    fi

    print_success "All production environment variables are set"
}

# Deploy backend to Coolify
deploy_backend_coolify() {
    print_status "Deploying backend to Coolify..."

    # Build and push backend image
    docker build -f backend/Dockerfile.prod -t feedback-widget-backend:latest ./backend

    # Tag for registry
    docker tag feedback-widget-backend:latest registry.coolify.io/feedback-widget-backend:latest

    # Push to Coolify registry
    docker push registry.coolify.io/feedback-widget-backend:latest

    # Deploy via Coolify API
    curl -X POST "https://coolify.your-domain.com/api/v1/services" \
        -H "Authorization: Bearer $COOLIFY_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
            "name": "feedback-widget-backend",
            "image": "registry.coolify.io/feedback-widget-backend:latest",
            "env": {
                "NODE_ENV": "production",
                "MONGODB_URI": "'"$MONGODB_ATLAS_URI"'",
                "JWT_SECRET": "'"$JWT_SECRET"'",
                "STRIPE_SECRET_KEY": "'"$STRIPE_SECRET_KEY"'",
                "FRONTEND_URL": "https://dashboard.'"$PRODUCTION_DOMAIN"'"
            },
            "ports": ["3001:3001"],
            "healthcheck": {
                "path": "/api/health",
                "interval": "30s"
            }
        }'

    print_success "Backend deployed to Coolify"
}

# Deploy landing page to Vercel
deploy_landing_vercel() {
    print_status "Deploying landing page to Vercel..."

    cd landing

    # Install Vercel CLI if not present
    if ! command -v vercel &> /dev/null; then
        npm install -g vercel
    fi

    # Deploy to Vercel
    vercel --prod --token "$VERCEL_TOKEN" \
        --env NODE_ENV=production \
        --env NEXT_PUBLIC_API_URL=https://api."$PRODUCTION_DOMAIN" \
        --env NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="$STRIPE_PUBLISHABLE_KEY"

    cd ..

    print_success "Landing page deployed to Vercel"
}

# Deploy widget to Cloudflare Pages
deploy_widget_cloudflare() {
    print_status "Deploying widget to Cloudflare Pages..."

    cd frontend

    # Build the widget
    npm run build

    # Create _headers file for Cloudflare Pages
    cat > dist/_headers << EOF
/*
  X-Frame-Options: SAMEORIGIN
  X-Content-Type-Options: nosniff
  Access-Control-Allow-Origin: *
  Cache-Control: public, max-age=31536000, immutable

/widget.js
  Access-Control-Allow-Origin: *
  Access-Control-Allow-Methods: GET
  Cache-Control: public, max-age=3600
EOF

    # Deploy to Cloudflare Pages
    npx wrangler pages deploy dist --compatibility-date 2024-01-01

    cd ..

    print_success "Widget deployed to Cloudflare Pages"
}

# Configure Cloudflare DNS and SSL
configure_cloudflare() {
    print_status "Configuring Cloudflare DNS and SSL..."

    # Add DNS records
    curl -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "type": "CNAME",
            "name": "api.'"$PRODUCTION_DOMAIN"'",
            "content": "your-coolify-domain.com",
            "ttl": 1,
            "proxied": true
        }'

    curl -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "type": "CNAME",
            "name": "dashboard.'"$PRODUCTION_DOMAIN"'",
            "content": "your-vercel-domain.vercel.app",
            "ttl": 1,
            "proxied": true
        }'

    curl -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "type": "CNAME",
            "name": "widget.'"$PRODUCTION_DOMAIN"'",
            "content": "your-cloudflare-pages-domain.pages.dev",
            "ttl": 1,
            "proxied": true
        }'

    print_success "Cloudflare DNS configured"
}

# Run production tests
run_production_tests() {
    print_status "Running production smoke tests..."

    # Wait for services to be ready
    sleep 60

    # Test backend health
    if curl -f https://api."$PRODUCTION_DOMAIN"/api/health > /dev/null 2>&1; then
        print_success "Backend health check passed"
    else
        print_error "Backend health check failed"
        exit 1
    fi

    # Test landing page
    if curl -f https://dashboard."$PRODUCTION_DOMAIN" > /dev/null 2>&1; then
        print_success "Landing page is accessible"
    else
        print_error "Landing page is not accessible"
        exit 1
    fi

    # Test widget
    if curl -f https://widget."$PRODUCTION_DOMAIN"/widget.js > /dev/null 2>&1; then
        print_success "Widget is accessible"
    else
        print_error "Widget is not accessible"
        exit 1
    fi

    print_success "All production tests passed"
}

# Main deployment flow
main() {
    print_status "Starting production deployment process..."

    # Change to project directory
    cd "$(dirname "$0")"

    # Check environment
    check_production_env

    # Deploy components
    deploy_backend_coolify
    deploy_landing_vercel
    deploy_widget_cloudflare

    # Configure infrastructure
    configure_cloudflare

    # Run tests
    run_production_tests

    print_success "🎉 Production deployment completed successfully!"
    echo ""
    echo "Production URLs:"
    echo "  - Landing Page: https://$PRODUCTION_DOMAIN"
    echo "  - Dashboard: https://dashboard.$PRODUCTION_DOMAIN"
    echo "  - API: https://api.$PRODUCTION_DOMAIN"
    echo "  - Widget: https://widget.$PRODUCTION_DOMAIN/widget.js"
    echo ""
    echo "Don't forget to:"
    echo "  - Update Stripe webhook endpoints"
    echo "  - Configure monitoring and alerting"
    echo "  - Set up backup strategies"
    echo "  - Update DNS records if needed"
}

# Run main function with all arguments
main "$@"