# Feedback Widget SaaS

Un sistema SaaS completo para recolección de feedback de usuarios mediante un widget flotante con 4 emojis. Construido con arquitectura multi-tenant, privacidad-first y integración completa con Stripe.

## 🏗️ Arquitectura

### Componentes del Sistema

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

### Stack Tecnológico

- **Frontend Widget**: JavaScript vanilla, Webpack, Jest
- **Backend API**: Node.js, Express, MongoDB, JWT
- **Landing/Dashboard**: Next.js, Tailwind CSS, shadcn/ui
- **Base de Datos**: MongoDB Atlas
- **Pagos**: Stripe API
- **Despliegue**: Docker, Coolify, Cloudflare Pages, Vercel
- **CI/CD**: GitHub Actions

### Comunicación entre Componentes

1. **Widget → Backend**: HTTP POST con `x-widget-id` header
2. **Landing → Backend**: REST API con JWT authentication
3. **Backend → Stripe**: Webhooks y API calls
4. **Backend → MongoDB**: Mongoose ODM

## 🚀 Inicio Rápido

### Prerrequisitos

- Node.js 18+
- Docker & Docker Compose
- MongoDB (local o Atlas)
- Cuentas: Stripe, Cloudflare, Vercel (opcional)

### Instalación Local

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/your-org/feedback-widget.git
   cd feedback-widget
   ```

2. **Configurar variables de entorno**
   ```bash
   # Backend
   cp backend/.env.example backend/.env
   # Editar backend/.env con tus credenciales

   # Landing
   cp landing/.env.example landing/.env.local
   # Editar landing/.env.local
   ```

3. **Levantar servicios locales**
   ```bash
   # Opción A: Docker Compose (recomendado)
   docker-compose up -d

   # Opción B: Desarrollo local
   cd backend && npm install && npm run dev &
   cd landing && npm install && npm run dev &
   cd frontend && npm install && npm run build
   ```

4. **Verificar funcionamiento**
   - Landing: http://localhost:3000
   - API: http://localhost:3001/api/health
   - Widget: http://localhost:80/widget.js

## 🔐 Credenciales y Configuración

### Variables de Entorno Requeridas

#### Backend (.env)
```bash
# Servidor
PORT=3001
NODE_ENV=development

# Base de datos
MONGODB_URI=mongodb://localhost:27017/feedbackwidget

# Autenticación
JWT_SECRET=your-super-secret-jwt-key-here

# Stripe (para pagos)
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

# Precios de Stripe
STRIPE_PRICE_STARTER=price_starter_monthly
STRIPE_PRICE_GROWTH=price_growth_monthly
STRIPE_PRICE_AGENCY=price_agency_monthly

# URLs
FRONTEND_URL=http://localhost:3000
```

#### Landing (.env.local)
```bash
# API
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_FRONTEND_URL=http://localhost:3000

# Stripe (cliente)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key

# Analytics (opcional)
NEXT_PUBLIC_GA_TRACKING_ID=
NEXT_PUBLIC_MIXPANEL_TOKEN=

# Autenticación
NEXTAUTH_SECRET=your-nextauth-secret
NEXTAUTH_URL=http://localhost:3000
```

### Credenciales de Servicios Externos

#### MongoDB Atlas
1. Crear cluster en https://cloud.mongodb.com
2. Crear usuario de base de datos
3. Whitelist IPs (0.0.0.0/0 para desarrollo)
4. Obtener connection string

#### Stripe
1. Crear cuenta en https://stripe.com
2. Obtener API keys del dashboard
3. Crear productos y precios
4. Configurar webhook endpoints

#### Cloudflare (Opcional)
1. Crear cuenta en https://cloudflare.com
2. Agregar dominio
3. Configurar DNS
4. Obtener API token

#### Vercel (Opcional)
1. Crear cuenta en https://vercel.com
2. Instalar Vercel CLI
3. Obtener token de autenticación

## 📦 Despliegue

### Opción 1: Despliegue Local Completo

```bash
# Usando Docker Compose
docker-compose up -d

# Ver logs
docker-compose logs -f
```

### Opción 2: Despliegue en Producción

#### Paso 1: Configurar Servicios Externos
```bash
# MongoDB Atlas
# Crear cluster y obtener connection string

# Stripe
# Crear cuenta y productos

# Cloudflare
# Configurar dominio y DNS
```

#### Paso 2: Desplegar Backend
```bash
# Usando Coolify (recomendado)
./deploy-production.sh

# O manualmente con Docker
cd backend
docker build -f Dockerfile.prod -t feedback-widget-backend .
docker run -p 3001:3001 --env-file .env.production feedback-widget-backend
```

#### Paso 3: Desplegar Landing
```bash
# Usando Vercel
cd landing
vercel --prod

# O usando Docker
docker build -f Dockerfile.prod -t feedback-widget-landing .
docker run -p 3000:3000 --env-file .env.production feedback-widget-landing
```

#### Paso 4: Desplegar Widget
```bash
# Usando Cloudflare Pages
cd frontend
npm run build
npx wrangler pages deploy dist

# O usando Docker
docker build -f Dockerfile.prod -t feedback-widget-frontend .
docker run -p 80:80 feedback-widget-frontend
```

### Configuración de Producción

Ver el archivo `PRODUCTION_SETUP.md` para instrucciones detalladas de configuración de producción.

## 🧪 Testing

### Ejecutar Tests
```bash
# Backend
cd backend && npm test

# Frontend Widget
cd frontend && npm test -- --coverage

# Landing (build incluye tests)
cd landing && npm run build
```

### Coverage Actual
- **Frontend Widget**: 81.65% statement coverage
- **Backend API**: Tests básicos implementados
- **Landing**: Build exitoso con TypeScript

## 📚 API Documentation

La documentación completa de la API está disponible en `backend/openapi.yml`.

### Endpoints Principales

- `POST /api/auth/register` - Registro de usuarios
- `POST /api/auth/login` - Login
- `POST /api/feedback` - Enviar feedback (público)
- `GET /api/analytics/overview` - Analytics
- `GET /api/feedback/recent` - Feedback reciente
- `POST /api/stripe/create-checkout-session` - Pagos

### Autenticación
La mayoría de endpoints requieren JWT token:
```
Authorization: Bearer your_jwt_token
```

## 🔒 Seguridad

### Medidas Implementadas
- **Rate Limiting**: 100 requests/15min por IP
- **Helmet.js**: Headers de seguridad HTTP
- **CORS**: Control de origen cruzado
- **JWT**: Autenticación stateless
- **bcrypt**: Hashing de passwords
- **Input Validation**: Sanitización de datos
- **GDPR Compliance**: Sin cookies de tracking

### Límites de Uso
- **Free**: 250 reacciones/mes
- **Starter**: 10,000 reacciones/mes
- **Growth**: 50,000 reacciones/mes
- **Agency**: Ilimitado

## 📊 Monitoreo y Analytics

### Métricas Incluidas
- Total de feedback recibido
- Rating promedio
- Distribución de ratings
- Top journeys de usuario
- Uso por plan
- Estado de suscripciones

### Logs
- Request/response logging
- Error tracking
- Performance metrics
- Security events

## 🐛 Troubleshooting

### Problemas Comunes

#### Error de Conexión a MongoDB
```bash
# Verificar connection string
mongo "your_connection_string"

# Verificar credenciales
db.auth("username", "password")
```

#### Error de Stripe Webhooks
```bash
# Verificar webhook secret
echo "webhook_secret" | openssl sha256 -hmac "your_webhook_secret"

# Verificar endpoint URL
curl -X POST your-webhook-endpoint \
  -H "Content-Type: application/json" \
  -d '{"type": "test"}'
```

#### Error de Build
```bash
# Limpiar node_modules
rm -rf node_modules package-lock.json
npm install

# Verificar Node.js version
node --version  # Debe ser 18+
```

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

### Guías de Código
- **Imports**: External first, then local, alphabetical
- **Formatting**: ESLint + Prettier
- **Types**: Explicit typing preferido
- **Testing**: Cobertura mínima 70%
- **Commits**: Conventional commits

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo `LICENSE` para más detalles.

## 🔧 Correcciones Recientes

### Problema de Compilación Next.js
**Síntoma**: Error `Cannot find module 'critters'` al ejecutar `npm run dev` o `npm run build`

**Causa**: Configuraciones avanzadas en `next.config.js` que requerían dependencias adicionales no instaladas

**Solución**: Simplificar `next.config.js` removiendo configuraciones experimentales:
```javascript
// ❌ Configuración problemática
experimental: {
  optimizeCss: true,  // Requiere 'critters'
  scrollRestoration: true,
}

// ✅ Configuración corregida
// Remover configuraciones experimentales hasta que las dependencias estén instaladas
```

**Lección**: Siempre verificar que las dependencias requeridas estén instaladas antes de agregar configuraciones avanzadas.

## 📞 Soporte

- **Email**: support@feedbackwidget.com
- **Docs**: https://docs.feedbackwidget.com
- **Issues**: https://github.com/your-org/feedback-widget/issues

## 🎯 Roadmap

### Próximas Features
- [ ] Integración con Slack
- [ ] Dashboard avanzado con gráficos
- [ ] Export de datos
- [ ] API rate limiting personalizado
- [ ] Multi-language support
- [ ] White-label option

### Mejoras Técnicas
- [ ] GraphQL API
- [ ] Redis caching
- [ ] CDN optimization
- [ ] A/B testing framework
- [ ] Advanced analytics

---

**Feedback Widget SaaS** - Recolecta feedback genuino sin comprometer la privacidad de tus usuarios.