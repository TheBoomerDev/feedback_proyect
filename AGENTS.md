# AGENTS.md - Sistema de Gestión de Tareas y Agentes

Este archivo gestiona el estado de las tareas y los agentes especializados del proyecto Feedback Widget SaaS.

## 📋 Estructura del Proyecto

```
feedback-widget/
├── backend/     → Repositorio independiente (API REST + MongoDB)
├── frontend/    → Repositorio independiente (Widget JS + Dashboard UI)
└── landing/     → Repositorio independiente (Next.js SEO + Marketing)
```

**Cada directorio es un repositorio git separado** - los commits deben hacerse independientemente.

## 🎯 Estrategia del Proyecto

- **API-First**: Todo está diseñado alrededor de la API REST
- **AI-First**: Arquitectura preparada para integración AI
- **Testing-First**: Testing prioritario sobre nuevas funcionalidades
- **shadcn-based**: UI con bloques funcionales de shadcn/ui
- **SEO/GEO**: Orientado a descubrimiento API/AI

## 🤖 Agentes Especializados

### @landing-agent (Next.js + SEO)
**Objetivo**: Web pública optimizada para SEO/GEO con descubrimiento API/AI

**Skills primarios**:
- `seo-audit` - Auditoría SEO técnica
- `programmatic-seo` - Páginas SEO a escala
- `web-accessibility` - WCAG compliance
- `react-expert` - React/Next.js patterns
- `playwright-skill` - E2E testing

**Responsabilidades**:
- Marketing pages optimizadas para SEO
- Integración con shadcn/ui blocks
- Testing E2E con Playwright
- OpenAPI documentation para descubrimiento

### @frontend-agent (Dashboard + UI)
**Objetivo**: Dashboards y configuración humana con shadcn

**Skills primarios**:
- `frontend-design` - UI/UX production-grade
- `shadcn` - Componentes pre-construidos
- `react-ui-patterns` - React patterns modernos
- `typescript-react-patterns` - Type-safe React
- `javascript-testing-patterns` - Testing strategies

**Responsabilidades**:
- Dashboard de analytics
- Configuración de widget
- Gestión de usuarios
- Integración con backend API
- Testing unitario + integración

### @backend-agent (API REST)
**Objetivo**: API robusta, documentada y testeada

**Skills primarios**:
- `api-design-principles` - REST API design
- `openapi-spec-generation` - OpenAPI 3.1 specs
- `express-rest-api` - Express.js patterns
- `backend-testing` - Comprehensive testing
- `mongoose-mongodb` - MongoDB ODM

**Responsabilidades**:
- API REST documentada
- Rate limiting y security
- MongoDB schema design
- JWT authentication
- Stripe webhooks
- Testing comprehensive

### @testing-agent (Quality Assurance)
**Objetivo**: Testing prioritario sobre nuevas features

**Skills primarios**:
- `test-driven-development` - TDD methodology
- `javascript-testing-patterns` - Jest/Vitest patterns
- `playwright-best-practices` - E2E testing
- `backend-testing` - API testing

**Responsabilidades**:
- Definir estrategia de testing
- Revisar coberturas de tests
- Implementar tests críticos
- Validar calidad de código

### @devops-agent (CI/CD + GitFlow)
**Objetivo**: Workflow y despliegue automatizado

**Skills primarios**:
- `git-workflow` - Git branching strategies
- `semantic-git` - Conventional commits
- `github-actions-templates` - CI/CD workflows
- `environment-setup` - Environment management

**Responsabilidades**:
- Mantener gitFlow
- Gestión de branches
- CI/CD pipelines
- Release management

## 📊 Estado Actual de Tareas

### ⚠️ CRÍTICO - Análisis Completo Completado (2026-03-18)

**Progreso General del Proyecto**: 40% completo

### Issues Críticos Detectados

#### 🚨 Seguridad (Bloqueantes de Producción)
| Issue | Severidad | Componente | Estado |
|-------|-----------|------------|--------|
| XSS en dashboard | Critical | Landing | ❌ No iniciado |
| JWT en localStorage | Critical | Landing | ❌ No iniciado |
| Sin CSRF protection | High | Backend | ❌ No iniciado |
| Contraseñas débiles (6 chars) | High | Backend | ❌ No iniciado |
| Sin rate limiting en auth | High | Backend | ❌ No iniciado |
| Sin validación de inputs | High | Backend | ❌ No iniciado |

#### 🔴 Funcionalidad Core Faltante
| Feature | Prioridad | Componente | Estado |
|---------|-----------|------------|--------|
| Dashboard sin API real | Critical | Landing | ❌ No iniciado |
| Sin gestión de perfiles | High | Landing | ❌ No iniciado |
| Sin notificaciones | High | Backend | ❌ No iniciado |
| Solo 1 widget por usuario | High | Backend | ❌ No iniciado |

#### 🧪 Testing Crítico Faltante
| Test Gap | Tipo | Componente | Estado |
|----------|------|------------|--------|
| Sin tests E2E | E2E | All | ❌ No iniciado |
| Auth flows sin test | Integration | Backend | ❌ No iniciado |
| Payments sin test | Integration | Backend | ❌ No iniciado |
| Sin tests de seguridad | Security | All | ❌ No iniciado |

### Tareas Activas
| ID | Tarea | Agente | Repositorio | Estado | Prioridad |
|----|-------|--------|-------------|--------|-----------|
| FASE-1 | Seguridad Crítica (40h) | @backend-agent + @frontend-agent | All | 🟡 Pendiente | Critical |

### Próximas Tareas (Orden de Ejecución)

1. **SEC-LAND-001**: Eliminar XSS vulnerability (4h)
2. **SEC-LAND-002**: Secure token storage (4h)
3. **SEC-BACK-001**: Input validation con Zod (6h)
4. **SEC-BACK-002**: CSRF protection (2h)
5. **SEC-BACK-003**: Rate limiting en auth (2h)
6. **SEC-BACK-004**: Password strengthening (2h)

*Ver [PROJECT_STATUS.md](./PROJECT_STATUS.md) para detalles completos*

### Tareas Completadas (Sesión Actual: 2026-03-18 → 2026-03-20)

#### Backend API - Migración a Clerk ✅
| Commit | Descripción | Fecha |
|--------|-------------|-------|
| `dae60bb` | feat(auth): migrate from custom JWT to Clerk authentication | 2026-03-18 |
| `c44256b` | feat(db): implement privacy-first architecture with Widget model | 2026-03-18 |
| `79e0d4c` | feat(config): change backend default port from 3001 to 4001 | 2026-03-20 |
| `85f6c7a` | test: add ESLint config and verification scripts | 2026-03-20 |

#### Cambios Realizados
1. **Autenticación Clerk** ✅
   - Instalación de @clerk/backend y @clerk/clerk-js
   - Middleware `requireAuth` personalizado con `verifyToken()`
   - Webhooks: user.created, user.updated, user.deleted
   - Lazy sync: crea usuario si no existe en MongoDB
   - Eliminadas rutas /register y /login
   - Nuevas rutas: /api/auth/me, /api/auth/webhook, /api/auth/widgets

2. **Privacy-First Architecture** ✅
   - Nuevo modelo `Widget` separado de `User`
   - Eliminado `Feedback.userId` (violaba privacidad)
   - Eliminado `metadata.cookieEnabled` (violaba "no cookies")
   - Movida config de widget de `User.settings` a `Widget.config`
   - Actualizado Stripe para resetear `Widget.usage`
   - Script de migración: 7 pasos
   - Tests de verificación: 100% anónimo
   - Agregación anónima para analytics

3. **Cambio de Puerto** ✅
   - Backend: 3001 → 4001 (resuelve conflicto con landing)
   - Actualizados todos los archivos de configuración
   - Actualizados Dockerfile y Dockerfile.prod
   - Actualizado openapi.yml
   - Actualizada documentación (.md files)

#### Commits Realizados
```bash
85f6c7a test: add ESLint config and verification scripts
79e0d4c feat(config): change backend default port from 3001 to 4001
c44256b feat(db): implement privacy-first architecture with Widget model
dae60bb feat(auth): migrate from custom JWT to Clerk authentication
a5592b8 feat: Complete backend API implementation
```

#### Estado del Backend
- ✅ Servidor arranca sin errores
- ✅ MongoDB connection OK
- ✅ Health endpoint OK (http://localhost:4001/api/health)
- ✅ Clerk middleware integrado
- ✅ Modelos actualizados (User, Widget, Feedback)
- ✅ Webhooks configurados
- ⏳ Endpoints protegidos sin test (requieren token de Clerk)
- ⏳ Webhooks sin test (requieren payload real de Clerk)

#### Próximos Pasos Backend
1. **Configurar remote de git** (actualmente no existe)
2. **Test endpoints protegidos** (requiere Clerk token)
3. **Test webhooks** (requiere payload real)
4. **Integración Frontend-Backend** (landing/dashboard)

#### Archivos Creados/Modificados
**Creados**:
- `.gitignore` - Node.js standard
- `CLERK_MIGRATION_COMPLETED.md` - Documentación de migración
- `CLERK_MIGRATION_PLAN.md` - Plan de migración
- `MONGODB_PRIVACY_FIRST_COMPLETED.md` - Documentación privacy-first
- `BACKEND_TESTING_COMPLETED.md` - Tests completados
- `BACKEND_MODIFICATIONS_PLAN.md` - Plan de modificaciones
- `src/models/Widget.js` - Nuevo modelo Widget
- `src/migrations/privacyFirstMigration.js` - Script de migración
- `src/test-mongodb.js` - Tests de verificación
- `openapi.yml` - OpenAPI 3.1 spec (v2.0 con Clerk)
- `.eslintrc.js` - Config ESLint
- `src/routes.test.js` - Tests de rutas
- `src/verify-schema.js` - Verificación de schema

**Modificados**:
- `src/index.js` - Integración Clerk + Widget (PORT: 4001)
- `src/models/User.js` - Clerk: clerkUserId, sin password
- `src/models/Feedback.js` - Privacy-first: widgetId, sin userId
- `src/routes/auth.js` - Rewrite completo para Clerk
- `src/routes/stripe.js` - Reset Widget.usage
- `package.json` - Dependencias @clerk/backend, @clerk/clerk-js, svix
- `.env.example`, `.env.staging`, `.env.production` - PORT: 4001
- `Dockerfile`, `Dockerfile.prod` - EXPOSE 4001
- `README.md` - PORT: 4001
- `*.md` - localhost:3001 → localhost:4001

### Tareas Completadas (Sesión Anterior: 2026-03-18)
| ID | Tarea | Agente | Repositorio | Fecha |
|----|-------|--------|-------------|-------|
| 001 | Crear CLAUDE.md | - | root | 2026-03-18 |
| 002 | Crear AGENTS.md | - | root | 2026-03-18 |
| 003 | Análisis completo del proyecto | Explore agent | All | 2026-03-18 |
| 004 | Crear PROJECT_PLAN.md (6 fases, 400+ líneas) | - | root | 2026-03-18 |
| 005 | Crear PROJECT_STATUS.md | - | root | 2026-03-18 |
| 006 | Crear executive summary en memoria | - | memory | 2026-03-18 |
| 007 | Actualizar AGENTS.md con tareas críticas | - | root | 2026-03-18 |

## 🔄 Flujo de Trabajo GitFlow

### Branches por Repositorio

```bash
# Cada repositorio tiene su propia estructura
backend/
├── main        ← Production
├── develop     ← Desarrollo integrado
├── feature/*   ← Features individuales
└── hotfix/*    ← Fixes urgentes

frontend/
├── main
├── develop
├── feature/*
└── hotfix/*

landing/
├── main
├── develop
├── feature/*
└── hotfix/*
```

### Workflow Standard

1. **Crear feature branch**
   ```bash
   cd backend  # o frontend, o landing
   git checkout develop
   git pull origin develop
   git checkout -b feature/nombre-feature
   ```

2. **Desarrollar con TDD**
   - Escribir tests primero
   - Implementar funcionalidad
   - Mantener cobertura > 70%

3. **Commit con convencional**
   ```bash
   git commit -m "feat: add user analytics endpoint"
   git commit -m "test: add coverage for feedback API"
   ```

4. **PR a develop**
   - Code review automatizado
   - CI/CD checks
   - Merge tras aprobación

5. **Release a main**
   - Desde develop
   - Versionado semántico
   - Changelog automático

## 🧠 Testing Strategy

### Prioridad de Testing
1. **Críticos**: Auth, payments, data persistence
2. **Alta**: API endpoints, core business logic
3. **Media**: UI components, dashboards
4. **Baja**: Marketing pages, static content

### Cobertura Objetivo
- Backend API: > 80%
- Frontend Widget: > 75%
- Landing/Dashboard: > 70%

### Tipos de Tests
- **Unit**: Jest/Vitest para funciones puras
- **Integration**: Supertest para API endpoints
- **E2E**: Playwright para user flows
- **Security**: Ghost Security scans

## 📖 Documentación

### API Documentation
- OpenAPI 3.1 spec en `backend/openapi.yml`
- Auto-generada desde código
- Ejemplos de usage

### Code Documentation
- JSDoc para funciones públicas
- Type definitions estrictas
- README en cada módulo

## 🚀 Próximos Pasos

1. ✅ Crear AGENTS.md
2. ⏳ Configurar sistema de tareas
3. ⏳ Implementar primer feature con TDD
4. ⏳ Establecer métricas de calidad

---

**Última actualización**: 2026-03-18
**Maintainer**: Feedback Widget Team

## 🚀 Próximos Pasos (Sesión Siguiente)

### Inmediato
1. **Backend: Configurar git remote**
   - Actualmente NO hay remote configurado
   - Comando: `git remote add origin <URL>`

2. **Backend: Probar puerto 4001**
   - `npm run dev`
   - `curl http://localhost:4001/api/health`

3. **Backend: Test endpoints protegidos**
   - Requiere token de Clerk
   - `/api/auth/me`, `/api/auth/widgets`, `/api/analytics/overview`

### Notas Importantes
- Puerto backend: **4001** (resuelto conflicto con landing)
- Commits backend: **5 listos para push**
- Git remote: **NO CONFIGURADO** ⚠️
- Documentación: Ver archivos *_COMPLETED.md

---

**Última actualización**: 2026-03-20
**Estado**: Backend Clerk + Privacy-First ✅ | Esperando git remote ⚠️
