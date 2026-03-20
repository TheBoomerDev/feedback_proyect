# Production Environment Configuration
# This file documents all required environment variables and secrets for production deployment

## Required Environment Variables

### Domain Configuration
PRODUCTION_DOMAIN=yourdomain.com

### Coolify Configuration
COOLIFY_API_KEY=your_coolify_api_key
COOLIFY_USERNAME=your_coolify_username
COOLIFY_PASSWORD=your_coolify_password
COOLIFY_WEBHOOK_URL=https://coolify.your-domain.com/webhooks/deploy

### Cloudflare Configuration
CLOUDFLARE_API_TOKEN=your_cloudflare_api_token
CLOUDFLARE_ACCOUNT_ID=your_cloudflare_account_id
CLOUDFLARE_ZONE_ID=your_cloudflare_zone_id

### Vercel Configuration
VERCEL_TOKEN=your_vercel_token
VERCEL_ORG_ID=your_vercel_org_id
VERCEL_PROJECT_ID=your_vercel_project_id

### Database Configuration
MONGODB_ATLAS_URI=mongodb+srv://username:password@cluster.mongodb.net/feedbackwidget_prod

### Stripe Configuration
STRIPE_SECRET_KEY=sk_live_your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=pk_live_your_stripe_publishable_key
STRIPE_WEBHOOK_SECRET=whsec_your_live_webhook_secret

### Security
JWT_SECRET=your_secure_jwt_secret_min_32_chars

### Email Configuration (Optional)
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASS=your_sendgrid_api_key

### Analytics (Optional)
NEXT_PUBLIC_GA_TRACKING_ID=GA_MEASUREMENT_ID
NEXT_PUBLIC_MIXPANEL_TOKEN=your_mixpanel_token

## Setup Instructions

### 1. Domain Setup
- Purchase domain from registrar
- Configure DNS records in Cloudflare:
  - A record: @ -> your-server-ip
  - CNAME: api -> your-coolify-domain.com
  - CNAME: dashboard -> your-vercel-domain.vercel.app
  - CNAME: widget -> your-cloudflare-pages-domain.pages.dev

### 2. MongoDB Atlas
- Create MongoDB Atlas cluster
- Create database user with read/write permissions
- Whitelist IP addresses (0.0.0.0/0 for development, specific IPs for production)
- Get connection string

### 3. Stripe Setup
- Create Stripe account
- Get API keys from dashboard
- Create products and prices for each tier
- Configure webhook endpoints for subscription events

### 4. Coolify Setup
- Deploy Coolify instance
- Create projects for backend
- Configure environment variables
- Set up automatic deployments

### 5. Cloudflare Setup
- Create Cloudflare account
- Add domain to Cloudflare
- Configure DNS records
- Set up SSL/TLS encryption
- Configure Page Rules for security headers

### 6. Vercel Setup
- Create Vercel account
- Import landing page project
- Configure environment variables
- Set up custom domain

### 7. GitHub Secrets
Add the following secrets to your GitHub repository:
- COOLIFY_API_KEY
- COOLIFY_USERNAME
- COOLIFY_PASSWORD
- COOLIFY_WEBHOOK_URL
- CLOUDFLARE_API_TOKEN
- CLOUDFLARE_ACCOUNT_ID
- VERCEL_TOKEN
- VERCEL_ORG_ID
- VERCEL_PROJECT_ID

## Deployment Checklist

- [ ] Domain purchased and configured
- [ ] MongoDB Atlas cluster created
- [ ] Stripe account and products configured
- [ ] Coolify instance deployed
- [ ] Cloudflare account and DNS configured
- [ ] Vercel account created
- [ ] GitHub repository secrets configured
- [ ] Environment variables set in production
- [ ] SSL certificates configured
- [ ] Monitoring and alerting set up
- [ ] Backup strategies implemented