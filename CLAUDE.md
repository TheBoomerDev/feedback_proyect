# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 📚 Project Documentation

- **[AGENTS.md](./AGENTS.md)** - Task management system, specialized agents, and GitFlow workflow
- **[MEMORY.md](../../../.claude/projects/-home-admin-code-other-dreamTeam/memory/MEMORY.md)** - Project memory and quick reference
- **[feedback-widget-context.md](../../../.claude/projects/-home-admin-code-other-dreamTeam/memory/feedback-widget-context.md)** - Strategic context and development conventions

**⚠️ IMPORTANT**: Always consult AGENTS.md before starting work to understand task status and agent assignments.

## Project Overview

This is a multi-service SaaS platform for collecting user feedback via an embeddable emoji widget. The system consists of three independent components:

- **Backend API** (Node.js/Express) - REST API with MongoDB, Stripe integration, JWT auth
- **Frontend Widget** (Vanilla JS) - 15KB minified embeddable widget served via CDN
- **Landing/Dashboard** (Next.js) - Marketing site and user dashboard with shadcn/ui

The architecture is designed for scalability with independent deployment: backend to Coolify, widget to Cloudflare Pages, landing to Vercel.

### Strategic Approach
- **API-First**: All design centers around the REST API
- **AI-First**: Architecture prepared for AI system integration
- **Testing-First**: Test coverage prioritized over new features (TDD methodology)
- **SEO/GEO-AI**: Oriented towards API/AI discovery
- **shadcn-based**: UI built with shadcn/ui functional blocks for rapid development

## Development Commands

### Local Development (Docker Compose)
```bash
# Start all services (MongoDB, Backend, Frontend, Landing)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Backend (Node.js/Express)
```bash
cd backend
yarn install --legacy-peer-deps  # Use legacy-peer-deps for all packages
yarn dev          # Development with nodemon
yarn start        # Production
yarn test         # Run Jest tests
yarn lint         # ESLint
```

### Frontend Widget (Vanilla JS + Webpack)
```bash
cd frontend
yarn install --legacy-peer-deps
yarn dev          # Watch mode for development
yarn build        # Production build to dist/
yarn test         # Jest tests with coverage
```

### Landing/Dashboard (Next.js)
```bash
cd landing
yarn install --legacy-peer-deps
yarn dev          # Next.js dev server on port 3000
yarn build        # Production build
yarn start        # Production server
yarn lint         # Next.js lint
```

### Initial Setup
```bash
./init.sh         # One-time setup: creates .env files, installs deps, builds widget
```

## Architecture

### Multi-Service Communication

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Landing Page  │    │     Backend     │    │     Widget      │
│   (Next.js)     │◄──►│   (Node.js)     │◄──►│  (Vanilla JS)   │
│                 │    │                 │    │                 │
│ - Marketing     │    │ - API REST      │    │ - Cookie-free   │
│ - Onboarding    │    │ - MongoDB       │    │ - 4 emojis      │
│ - Dashboard     │    │ - JWT Auth      │    │ - Auto-init     │
│ - Payments      │    │ - Stripe        │    │ - 15KB minified │
└─────────────────┘    └─────────────────┘    └─────────────────┘
       │                       │                       │
       └───────────────────────┼───────────────────────┘
                               ▼
                    ┌─────────────────┐
                    │   MongoDB Atlas │
                    │   (Database)    │
                    └─────────────────┘
```

### Widget → Backend Flow
The widget identifies users via `x-widget-id` header. Feedback submission checks monthly usage limits before saving.

### Backend Data Models
- **Feedback**: sessionId, rating (1-4), comment, journey tracking, metadata, userId
- **User**: email, password (bcrypt), plan (free/starter/growth/agency), stripeCustomerId, widgetId, settings, usage tracking

### Authentication
- JWT tokens for protected routes (`/api/analytics`, `/api/feedback`, `/api/user`)
- Public routes: `/api/health`, `/api/auth/*`, `/api/feedback` (POST with widget-id)

### Rate Limiting
- 100 requests per 15 minutes per IP (express-rate-limit)

## CI/CD Pipeline

GitHub Actions (`.github/workflows/cicd.yml`):
1. Tests all three components in parallel
2. On main branch push: deploys to production
3. Automatic merges: main → demo → edu
4. Release-please for version management
5. Deployment targets: Coolify (backend), Cloudflare Pages (widget), Vercel (landing)

## GitFlow Workflow

**Each directory is a separate git repository** - commits must be made independently per directory.

### Branch Structure (per repository)
```bash
main        # Production code
develop     # Integration branch for features
feature/*   # Individual features
hotfix/*    # Urgent production fixes
```

### Feature Development Workflow
```bash
cd backend  # or frontend, or landing
git checkout develop
git pull origin develop
git checkout -b feature/feature-name

# Work with TDD: tests first, then implementation
git commit -m "feat: add user analytics endpoint"
git commit -m "test: add coverage for analytics"

git push origin feature/feature-name
# Create PR → develop
```

### Conventional Commits
Use semantic commit messages:
- `feat:` - New feature
- `fix:` - Bug fix
- `test:` - Adding/updating tests
- `docs:` - Documentation
- `refactor:` - Code refactoring
- `perf:` - Performance improvement
- `style:` - Code style changes
- `chore:` - Maintenance tasks

## Environment Setup

### Backend (.env)
Required: `MONGODB_URI`, `JWT_SECRET`, `PORT` (default 3001)
Optional: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, Stripe price IDs

### Landing (.env.local)
Required: `NEXT_PUBLIC_API_URL`, `NEXTAUTH_SECRET`, `NEXTAUTH_URL`
Optional: `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`, analytics IDs

### Package Manager
- Project uses **yarn** (packageManager field specifies 1.22.22)
- Use `yarn install --legacy-peer-deps` for dependency installation

## Testing Strategy

### Coverage Objectives
- **Backend API**: Target > 80% coverage (Jest + Supertest)
- **Frontend Widget**: Target > 75% coverage (Jest + jsdom, currently 81.65%)
- **Landing/Dashboard**: Target > 70% coverage (TypeScript validation via build)

### Testing Priority
1. **Critical**: Authentication, payments, data persistence
2. **High**: API endpoints, core business logic
3. **Medium**: UI components, dashboards
4. **Low**: Marketing pages, static content

### Testing Tools
- **Unit Tests**: Jest/Vitest for pure functions
- **Integration Tests**: Supertest for API endpoints
- **E2E Tests**: Playwright for user flows
- **Security**: Ghost Security for vulnerability scanning

### Current Status
- Frontend Widget: 81.65% statement coverage (Jest + jsdom)
- Backend API: Basic Jest tests with Supertest
- Landing: Build validates TypeScript; E2E tests to be implemented

## Important Development Notes

1. **Simplified next.config.js**: The landing page had issues with experimental configs requiring 'critters' dependency. Keep next.config.js minimal unless adding required dependencies.

2. **Multi-tenant Architecture**: All feedback/queries are scoped by userId. Usage limits are tracked monthly per user.

3. **Widget Integration**: Widget is served as standalone JavaScript file. Users embed via `<script src="https://cdn.feedbackwidget.com/{widgetId}.js"></script>`.

4. **Analytics**: Backend provides aggregation queries for overview stats, journey analysis, and transitions between pages.

5. **Stripe Integration**: Webhook endpoints handle subscription events. Price IDs are environment-specific.

## File Structure Notes

- `backend/src/` - Express app with models/, routes/, index.js
- `frontend/src/` - Single widget.js file with widget.test.js
- `landing/` - Next.js app with pages/, components/, lib/, utils/
- `docker-compose*.yml` - Local, staging, and production configurations
- `deploy-*.sh` - Deployment scripts for Coolify/Vercel/Cloudflare

## Relevant Skills by Component

### @landing (Next.js + SEO)
Use these skills when working on the landing page:
- `seo-audit` - SEO technical audits
- `programmatic-seo` - SEO pages at scale
- `web-accessibility` - WCAG compliance
- `react-expert` - React/Next.js patterns
- `playwright-skill` - E2E testing

### @frontend (Dashboard + UI)
Use these skills when working on dashboards:
- `frontend-design` - Production-grade UI/UX
- `shadcn` - Pre-built shadcn/ui components
- `react-ui-patterns` - Modern React patterns
- `typescript-react-patterns` - Type-safe React
- `javascript-testing-patterns` - Testing strategies

### @backend (API REST)
Use these skills when working on the API:
- `api-design-principles` - REST API design
- `openapi-spec-generation` - OpenAPI 3.1 specs
- `express-rest-api` - Express.js patterns
- `backend-testing` - Comprehensive testing
- `mongoose-mongodb` - MongoDB ODM

### Transversal Skills
Use these skills across all components:
- `test-driven-development` - TDD methodology (use before implementing features)
- `git-workflow` - Git branching strategies
- `semantic-git` - Conventional commits
- `github-actions-templates` - CI/CD workflows
