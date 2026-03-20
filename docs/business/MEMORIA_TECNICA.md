# MEMORIA TÉCNICA
## Feedback Widget SaaS

**Versión**: 1.0
**Fecha**: Marzo 2026
**Status**: En Desarrollo
**Technical Lead**: Feedback Widget Team

---

## 1. Introducción

### 1.1 Propósito del Documento

Este documento describe la arquitectura técnica, decisiones de diseño, patrones implementados y consideraciones tecnológicas del proyecto Feedback Widget SaaS. Sirve como referencia para el equipo de desarrollo y futuros mantenedores.

### 1.2 Alcance

La memoria técnica cubre:
- Arquitectura general del sistema
- Decisiones arquitectónicas y justificación
- Especificaciones técnicas de cada componente
- Patrones de diseño implementados
- Consideraciones de seguridad y rendimiento
- Estrategias de escalabilidad
- Gestión de datos y persistencia
- Integraciones con servicios externos

### 1.3 Definiciones

- **SaaS**: Software as a Service
- **MVP**: Minimum Viable Product
- **GDPR**: General Data Protection Regulation
- **WCAG**: Web Content Accessibility Guidelines
- **CDN**: Content Delivery Network
- **SSO**: Single Sign-On
- **API**: Application Programming Interface

---

## 2. Arquitectura del Sistema

### 2.1 Visión General

Feedback Widget SaaS implementa una arquitectura de microservicios con tres componentes principales:

```
┌─────────────────────────────────────────────────────────────┐
│                       CLIENT LAYER                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Widget     │  │   Landing    │  │  Dashboard   │      │
│  │  (Vanilla JS)│  │   (Next.js)  │  │  (Next.js)   │      │
│  │              │  │              │  │              │      │
│  │ • 4 emojis   │  │ • Marketing  │  │ • Analytics  │      │
│  │ • Journey    │  │ • Auth       │  │ • Settings   │      │
│  │ • Privacy    │  │ • Pricing    │  │ • Export     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       CDN LAYER                              │
│                    (Cloudflare)                              │
│  • Widget distribution    • DDoS protection                 │
│  • Static assets          • SSL termination                 │
│  • Edge caching           • Geo-routing                     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌────────────────────────────────────────────────────┐    │
│  │              API Gateway / Load Balancer            │    │
│  │  • Rate limiting    • Authentication               │    │
│  │  • Request routing  • SSL termination              │    │
│  └────────────────────────────────────────────────────┘    │
│                              │                               │
│         ┌────────────────────┼────────────────────┐         │
│         ▼                    ▼                    ▼         │
│  ┌──────────┐        ┌──────────┐        ┌──────────┐   │
│  │ Backend  │        │  Stripe  │        │  Email   │   │
│  │ Service  │        │ Webhooks │        │ Service  │   │
│  │(Node.js) │        │          │        │(SendGrid)│   │
│  └─────┬────┘        └──────────┘        └──────────┘   │
│        │                                                   │
│        ▼                                                   │
│  ┌────────────────────────────────────────────────────┐  │
│  │              Business Logic Layer                  │  │
│  │  • Feedback processing  • User management          │  │
│  │  • Analytics aggregation • Subscription mgmt        │  │
│  │  • Journey tracking      • Notification system     │  │
│  └────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                              │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   MongoDB    │  │    Redis     │  │   Storage    │      │
│  │   (Primary)  │  │   (Cache)    │  │  (Backups)   │      │
│  │              │  │              │  │              │      │
│  │ • Users      │  │ • Sessions   │  │ • Backups    │      │
│  │ • Feedback   │  │ • Queries    │  │ • Logs       │      │
│  │ • Widgets    │  │ • Rate limits│  │ • Archives   │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Decisiones Arquitectónicas

#### 2.2.1 Arquitectura de Microservicios

**Decisión**: Separar el sistema en tres servicios independientes (Widget, Landing, Dashboard).

**Justificación**:
- **Escalabilidad Independiente**: Cada componente puede escalar según demanda
- **Desacoplamiento**: Cambios en un componente no afectan otros
- **Flexibilidad Tecnológica**: Diferentes stacks para diferentes necesidades
- **Deploy Independiente**: Actualizaciones sin downtime del sistema completo

**Trade-offs**:
- Complejidad operacional aumentada
- Latencia de red entre servicios
- Necesidad de orquestación de deployments

#### 2.2.2 Multi-Repository Structure

**Decisión**: Cada componente en un repositorio git independiente.

**Justificación**:
- **Independencia de Desarrollo**: Teams pueden trabajar en paralelo sin conflictos
- **Versionado Separado**: Releases independientes por componente
- **Code Review Específico**: PRs enfocados en un componente
- **CI/CD Específico**: Pipelines optimizados por componente

**Trade-offs**:
- Duplicación de configuración (dev, test, CI)
- Compartición de código requiere packages compartidos
- Mayor coordinación para cambios跨界

### 2.3 Stack Tecnológico

#### 2.3.1 Frontend Widget (Vanilla JavaScript)

**Tecnologías**:
- JavaScript ES6+ (Vanilla, sin frameworks)
- Webpack 5 (Bundling)
- Babel (Transpilation)
- Jest + jsdom (Testing)

**Justificación**:
- **Performance**: Sin overhead de frameworks, ~15KB minified
- **Compatibility**: Funciona en cualquier sitio web
- **Simplicity**: Fácil de integrar (un script tag)
- **Maintenance**: Menos dependencies, menor risk de vulnerabilities

**Características técnicas**:
```javascript
class FeedbackWidget {
  constructor(config) {
    this.config = config;
    this.journey = [];
    this.sessionId = this.generateSessionId();
  }

  init() {
    this.trackJourney();
    this.injectWidget();
    this.attachListeners();
  }

  // Privacy: No cookies, no localStorage
  generateSessionId() {
    return 'sess_' + Math.random().toString(36).substr(2, 9);
  }
}
```

#### 2.3.2 Landing/Dashboard (Next.js)

**Tecnologías**:
- Next.js 14 (React framework)
- React 18 (UI library)
- TypeScript 5 (Type safety)
- Tailwind CSS (Styling)
- shadcn/ui (Component library)

**Justificación**:
- **SEO Optimization**: Next.js SSR/SSG para mejor ranking
- **Performance**: Automatic code splitting, optimized images
- **Developer Experience**: TypeScript para type safety
- **UI Consistency**: shadcn/ui para componentes production-ready
- **Modern Stack**: React ecosystem con mejores prácticas

**Arquitectura de componentes**:
```
landing/
├── pages/
│   ├── index.js          # Landing page
│   ├── login.js          # Authentication
│   ├── register.js       # Registration
│   └── dashboard.js      # Main dashboard
├── components/
│   ├── ui/               # shadcn/ui components
│   ├── Dashboard/        # Dashboard-specific components
│   └── Auth/             # Authentication components
├── lib/                  # Utilities
└── styles/               # Global styles
```

#### 2.3.3 Backend API (Node.js/Express)

**Tecnologías**:
- Node.js 18+ (Runtime)
- Express.js 4 (Web framework)
- MongoDB + Mongoose (Database)
- JWT (Authentication)
- Stripe (Payments)
- Winston/Bunyan (Logging)

**Justificación**:
- **Ecosystem Rich**: NPM ecosystem más grande
- **Performance**: V8 engine, async/await nativo
- **Scalability**: Event loop para alta concurrencia
- **Community**: Amplia documentación y soporte
- **MongoDB**: Flexible schema para analytics

**Arquitectura en capas**:
```javascript
// Middleware Layer
app.use(helmet());        // Security headers
app.use(compression());   // Response compression
app.use(cors());          // CORS handling
app.use(rateLimit());     // Rate limiting

// Authentication Layer
app.use('/api/auth', authRoutes);
app.use('/api/analytics', authenticateToken);

// Business Logic Layer
app.get('/api/analytics/overview', async (req, res) => {
  // MongoDB aggregation pipelines
  const stats = await Feedback.aggregate([...]);
  res.json(stats);
});

// Data Access Layer
const Feedback = mongoose.model('Feedback');
```

### 2.4 Base de Datos

#### 2.4.1 Schema Design

**User Schema**:
```javascript
{
  email: {
    type: String,
    unique: true,
    required: true,
    index: true
  },
  password: {
    type: String,
    required: true,
    bcrypt: true
  },
  plan: {
    type: String,
    enum: ['free', 'starter', 'growth', 'agency'],
    default: 'free'
  },
  stripeCustomerId: String,
  stripeSubscriptionId: String,
  settings: {
    emailNotifications: Boolean,
    weeklyDigest: Boolean,
    timezone: String
  },
  usage: {
    reactions: Number,
    month: String  // YYYY-MM format
  }
}
```

**Feedback Schema**:
```javascript
{
  sessionId: {
    type: String,
    required: true,
    index: true
  },
  rating: {
    type: Number,
    required: true,
    min: 1,
    max: 4
  },
  comment: String,
  journey: [{
    path: String,
    timestamp: Number,
    referrer: String
  }],
  metadata: {
    userAgent: String,
    language: String,
    platform: String,
    screenResolution: String
  },
  userId: {
    type: ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  createdAt: {
    type: Date,
    default: Date.now,
    index: true
  }
}
```

**Indexes para Performance**:
```javascript
// Compound indexes para queries comunes
Feedback.index({ userId: 1, createdAt: -1 });
Feedback.index({ userId: 1, rating: 1 });
Feedback.index({ sessionId: 1 });

// Covering queries
Feedback.index({
  userId: 1,
  createdAt: -1,
  rating: 1
});
```

#### 2.4.2 MongoDB Aggregation Pipelines

**Analytics Overview**:
```javascript
Feedback.aggregate([
  // Match por usuario y fecha
  { $match: {
    userId: mongoose.Types.ObjectId(userId),
    createdAt: { $gte: startDate, $lte: endDate }
  }},

  // Group y cálculos
  { $group: {
    _id: null,
    totalFeedback: { $sum: 1 },
    averageRating: { $avg: '$rating' },
    ratingDistribution: { $push: '$rating' }
  }},

  // Project resultados
  { $project: {
    totalFeedback: 1,
    averageRating: { $round: ['$averageRating', 2] },
    ratingDistribution: 1
  }}
]);
```

**Journey Analysis**:
```javascript
Feedback.aggregate([
  { $match: { userId: ObjectId(userId) }},

  // Unwind journey array
  { $unwind: '$journey' },

  // Group por path
  { $group: {
    _id: '$journey.path',
    count: { $sum: 1 },
    avgRating: { $avg: '$rating' },
    uniqueSessions: { $addToSet: '$sessionId' }
  }},

  // Sort y limit
  { $sort: { count: -1 }},
  { $limit: 10 }
]);
```

### 2.5 Seguridad

#### 2.5.1 Autenticación

**JWT-based Stateless Authentication**:
```javascript
// Token generation
const token = jwt.sign(
  { userId: user._id, email: user.email },
  process.env.JWT_SECRET,
  { expiresIn: '7d' }
);

// Middleware de autenticación
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.sendStatus(401);

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};
```

**Password Hashing**:
```javascript
// bcrypt con salt rounds
const saltRounds = 12;
const hashedPassword = await bcrypt.hash(password, saltRounds);

// Password verification
const match = await bcrypt.compare(candidatePassword, hashedPassword);
```

#### 2.5.2 Seguridad en Headers

**Helmet.js Configuration**:
```javascript
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"]
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  },
  noSniff: true,
  xssFilter: true
}));
```

#### 2.5.3 Rate Limiting

**Express Rate Limiter**:
```javascript
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP',
  standardHeaders: true,
  legacyHeaders: false,
});

// Rate limiting específico para auth
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // More aggressive for auth
  skipSuccessfulRequests: true
});
```

#### 2.5.4 Input Validation

**Zod Schema Validation**:
```javascript
const feedbackSchema = z.object({
  sessionId: z.string().min(1),
  rating: z.number().min(1).max(4),
  comment: z.string().max(1000).optional(),
  journey: z.array(z.object({
    path: z.string(),
    timestamp: z.number(),
    referrer: z.string().optional()
  })),
  url: z.string().url()
});

// Middleware de validación
const validate = (schema) => (req, res, next) => {
  try {
    schema.parse(req.body);
    next();
  } catch (error) {
    res.status(400).json({ error: error.errors });
  }
};
```

### 2.6 Performance Optimization

#### 2.6.1 Database Optimization

**Indexing Strategy**:
```javascript
// Single field indexes
User.index({ email: 1 });
Feedback.index({ createdAt: -1 });

// Compound indexes
Feedback.index({ userId: 1, createdAt: -1 });
Feedback.index({ userId: 1, rating: 1 });

// Covered queries
Feedback.index({
  userId: 1,
  rating: 1,
  createdAt: 1
});
```

**Query Optimization**:
```javascript
// ❌ Ineficiente (múltiples queries)
const user = await User.findById(userId);
const feedbacks = await Feedback.find({ userId });

// ✅ Eficiente (una query con populate)
const feedbacks = await Feedback.find({ userId })
  .populate('userId', 'email plan');
```

#### 2.6.2 Caching Strategy

**Redis Caching**:
```javascript
const cache = async (key, query, ttl = 3600) => {
  // Check cache
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached);

  // Execute query
  const result = await query.exec();

  // Set cache
  await redis.setex(key, ttl, JSON.stringify(result));

  return result;
};

// Usage
const analytics = await cache(
  `analytics:${userId}:${dateRange}`,
  Feedback.aggregate([...]),
  1800  // 30 minutes
);
```

#### 2.6.3 CDN Configuration

**Cloudflare CDN**:
```javascript
// Widget distribution
// URL: https://cdn.feedbackwidget.com/widget.js
// Caching: 24 hours
// Versioning: ?v=x.y.z for cache busting

// Static assets
// URL: https://cdn.feedbackwidget.com/assets/
// Caching: 7 days
// Compression: Brotli + Gzip
```

### 2.7 Escalabilidad

#### 2.7.1 Horizontal Scaling

**Application Server**:
```yaml
# Docker Compose scale configuration
services:
  backend:
    image: feedback-widget-backend
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
    environment:
      - NODE_ENV=production
```

**Database Sharding**:
```javascript
// Shard key: userId
// Distributes data across multiple shards

const shardConfig = {
  userId: 1,  // Shard by userId
  // Distributes feedback across shards evenly
};
```

#### 2.7.2 Load Balancing

**Nginx Configuration**:
```nginx
upstream backend_servers {
    least_conn;
    server backend-1:3001 weight=1;
    server backend-2:3001 weight=1;
    server backend-3:3001 weight=1;
}

server {
    listen 443 ssl;
    server_name api.feedbackwidget.com;

    location /api/ {
        proxy_pass http://backend_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 2.8 Integraciones

#### 2.8.1 Stripe Integration

**Webhook Handling**:
```javascript
app.post('/api/stripe/webhook', async (req, res) => {
  const sig = req.headers['stripe-signature'];

  try {
    const event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );

    switch (event.type) {
      case 'checkout.session.completed':
        await handleCheckoutComplete(event.data.object);
        break;
      case 'customer.subscription.updated':
        await handleSubscriptionUpdate(event.data.object);
        break;
    }

    res.json({ received: true });
  } catch (err) {
    res.status(400).send(`Webhook Error: ${err.message}`);
  }
});
```

#### 2.8.2 Email Integration

**SendGrid Templates**:
```javascript
const sendEmail = async (to, templateId, dynamicData) => {
  await sgMail.send({
    to,
    from: 'noreply@feedbackwidget.com',
    templateId,
    dynamicTemplateData: dynamicData
  });
};

// Welcome email
await sendEmail(user.email, 'd-welcome-template', {
  username: user.email.split('@')[0],
  dashboard_url: 'https://dashboard.feedbackwidget.com'
});
```

#### 2.8.3 Webhook Integration

**Custom Webhooks**:
```javascript
const sendWebhook = async (url, event, payload) => {
  try {
    await axios.post(url, {
      event,
      timestamp: new Date().toISOString(),
      data: payload
    }, {
      headers: { 'Content-Type': 'application/json' },
      timeout: 5000
    });
  } catch (error) {
    // Queue for retry
    await retryQueue.add({ url, event, payload });
  }
};
```

---

## 3. Patrones de Diseño

### 3.1 Patrones Arquitectónicos

#### 3.1.1 Repository Pattern

```javascript
class FeedbackRepository {
  async findByUserId(userId, filters) {
    const query = { userId };
    if (filters.startDate && filters.endDate) {
      query.createdAt = {
        $gte: new Date(filters.startDate),
        $lte: new Date(filters.endDate)
      };
    }
    return await Feedback.find(query).sort({ createdAt: -1 });
  }

  async getAnalytics(userId, dateRange) {
    return await Feedback.aggregate([...]);
  }
}
```

#### 3.1.2 Factory Pattern

```javascript
class WidgetFactory {
  static create(type, config) {
    switch (type) {
      case 'emoji':
        return new EmojiWidget(config);
      case 'nps':
        return new NPSWidget(config);
      case 'rating':
        return new RatingWidget(config);
      default:
        throw new Error('Unknown widget type');
    }
  }
}
```

#### 3.1.3 Observer Pattern

```javascript
class FeedbackListener {
  constructor() {
    this.listeners = [];
  }

  subscribe(listener) {
    this.listeners.push(listener);
  }

  async notify(event, data) {
    for (const listener of this.listeners) {
      await listener.onFeedback(event, data);
    }
  }
}

// Usage
const listener = new FeedbackListener();
listener.subscribe(new SlackNotifier());
listener.subscribe(new EmailNotifier());
listener.subscribe(new AnalyticsTracker());
```

### 3.2 Patrones de Código

#### 3.2.1 Singleton Pattern

```javascript
class Database {
  static instance = null;

  constructor() {
    if (Database.instance) {
      return Database.instance;
    }
    this.connection = null;
    Database.instance = this;
  }

  async connect() {
    if (!this.connection) {
      this.connection = await mongoose.connect(process.env.MONGODB_URI);
    }
    return this.connection;
  }
}
```

#### 3.2.2 Middleware Pattern

```javascript
const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next))
    .catch(next);
};

// Usage
app.get('/api/analytics', asyncHandler(async (req, res) => {
  const analytics = await getAnalytics(req.user.userId);
  res.json(analytics);
}));
```

---

## 4. Testing Strategy

### 4.1 Testing Pyramid

```
                    /\
                   /  \
                  / E2E \           ← Playwright (10%)
                 /________\
                /          \
               /Integration \     ← Supertest (30%)
              /______________\
             /                \
            /    Unit Tests    \ ← Jest (60%)
           /____________________\
```

### 4.2 Unit Testing

**Frontend Widget**:
```javascript
describe('FeedbackWidget', () => {
  let widget;

  beforeEach(() => {
    document.body.innerHTML = '<div id="root"></div>';
    widget = new FeedbackWidget({ position: 'bottom-right' });
  });

  test('should initialize widget', () => {
    widget.init();
    expect(document.querySelector('.fw-widget')).toBeTruthy();
  });

  test('should track journey', () => {
    widget.trackPage('/test');
    expect(widget.journey.length).toBe(1);
  });
});
```

**Backend API**:
```javascript
describe('POST /api/feedback', () => {
  test('should create feedback with valid data', async () => {
    const response = await request(app)
      .post('/api/feedback')
      .set('x-widget-id', testWidgetId)
      .send({
        sessionId: 'test-session',
        rating: 4,
        comment: 'Great!'
      });

    expect(response.status).toBe(201);
    expect(response.body.success).toBe(true);
  });
});
```

### 4.3 Integration Testing

**API Endpoints**:
```javascript
describe('Analytics API', () => {
  test('should return overview analytics', async () => {
    const response = await request(app)
      .get('/api/analytics/overview')
      .set('Authorization', `Bearer ${token}`);

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('totalFeedback');
    expect(response.body).toHaveProperty('averageRating');
  });
});
```

### 4.4 E2E Testing

**User Flows**:
```javascript
test('Complete user registration flow', async ({ page }) => {
  await page.goto('/register');
  await page.fill('#email', 'test@example.com');
  await page.fill('#password', 'SecurePassword123!');
  await page.click('button[type="submit"]');

  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('h1')).toContainText('Welcome');
});
```

---

## 5. Deployment Strategy

### 5.1 CI/CD Pipeline

```yaml
# GitHub Actions Workflow
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - Checkout code
      - Setup Node.js
      - Install dependencies
      - Run tests
      - Upload coverage

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - Build Docker images
      - Push to registry
      - Deploy to staging

  production:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - Deploy to production
      - Run smoke tests
      - Notify team
```

### 5.2 Environment Configuration

**Staging Environment**:
- URL: staging.feedbackwidget.com
- Database: MongoDB Atlas staging cluster
- Email: SendGrid test mode
- Stripe: Test mode keys

**Production Environment**:
- URL: app.feedbackwidget.com
- Database: MongoDB Atlas production cluster
- Email: SendGrid production
- Stripe: Live keys
- Monitoring: Sentry + DataDog

### 5.3 Rollback Strategy

```bash
# Automatic rollback on failure
if [ $DEPLOY_STATUS != "success" ]; then
  echo "Deployment failed, rolling back..."
  kubectl rollout undo deployment/backend
  kubectl rollout undo deployment/frontend
  exit 1
fi

# Manual rollback to previous version
kubectl rollout undo deployment/backend --to-revision=3
```

---

## 6. Monitoring y Logging

### 6.1 Application Monitoring

**Sentry Error Tracking**:
```javascript
Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 0.1,
  beforeSend(event) {
    // Filter sensitive data
    if (event.request?.headers) {
      delete event.request.headers['authorization'];
    }
    return event;
  }
});
```

### 6.2 Logging Strategy

**Structured Logging**:
```javascript
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

// Usage
logger.info('Feedback received', {
  userId,
  rating,
  sessionId,
  timestamp: new Date().toISOString()
});
```

### 6.3 Health Checks

**Comprehensive Health Check**:
```javascript
app.get('/health/detailed', async (req, res) => {
  const health = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    checks: {
      database: await checkDatabase(),
      redis: await checkRedis(),
      stripe: await checkStripe(),
      email: await checkEmail()
    }
  };

  const isHealthy = Object.values(health.checks)
    .every(check => check.status === 'healthy');

  res.status(isHealthy ? 200 : 503).json(health);
});
```

---

## 7. Estrategia de Migración de Datos

### 7.1 Database Migrations

**Version Control de Schema**:
```javascript
const migrations = {
  001_add_widget_collection: {
    up: async () => {
      await db.createCollection('widgets');
      await db.collection('widgets').createIndex({ userId: 1 });
    },
    down: async () => {
      await db.collection('widgets').drop();
    }
  },

  002_add_multi_widget_support: {
    up: async () => {
      // Migrate existing users to multi-widget
      const users = await User.find({ widgetId: { $exists: true } });
      for (const user of users) {
        await Widget.create({
          userId: user._id,
          name: 'Default Widget',
          domain: user.domain
        });
      }
    },
    down: async () => {
      // Rollback migration
    }
  }
};
```

---

## 8. Consideraciones de Compliance

### 8.1 GDPR Compliance

**Privacy by Design**:
- No cookies en el widget
- No localStorage para datos sensibles
- No tracking o fingerprinting
- Data minimization (solo datos necesarios)
- Right to deletion (account + data deletion)

**Data Processing Agreement**:
```javascript
// Consent management
const consent = await UserConsent.create({
  userId: user._id,
  type: 'data_processing',
  accepted: true,
  date: new Date(),
  ipAddress: req.ip
});
```

### 8.2 Accessibility

**WCAG 2.1 AA Compliance**:
- Semantic HTML
- ARIA labels
- Keyboard navigation
- Screen reader compatibility
- Color contrast ratios ≥ 4.5:1

---

## 9. Futuras Mejoras Técnicas

### 9.1 Short-term (3-6 meses)
- TypeScript migration en backend
- Redis caching layer
- GraphQL API alternativa
- WebSocket para real-time updates

### 9.2 Medium-term (6-12 meses)
- Microservices para analytics
- Event-driven architecture (Kafka)
- Machine learning pipeline
- Advanced security features (2FA, SSO)

### 9.3 Long-term (12+ meses)
- Multi-region deployment
- Database sharding
- Custom database engine
- Edge computing integration

---

## 10. Anexos

### Anexo A: Variables de Entorno

```bash
# Database
MONGODB_URI=mongodb+srv://...
REDIS_URL=redis://...

# Authentication
JWT_SECRET=...
JWT_EXPIRES_IN=7d

# Stripe
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
STRIPE_PRICE_STARTER=price_...
STRIPE_PRICE_GROWTH=price_...
STRIPE_PRICE_AGENCY=price_...

# Email
SENDGRID_API_KEY=SG....
SENDGRID_FROM_EMAIL=noreply@feedbackwidget.com

# Monitoring
SENTRY_DSN=https://...
DATADOG_API_KEY=...

# Application
NODE_ENV=production
API_URL=https://api.feedbackwidget.com
FRONTEND_URL=https://app.feedbackwidget.com
```

### Anexo B: Endpoints API

**Authentication**:
- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/logout
- POST /api/auth/forgot-password
- POST /api/auth/reset-password

**Feedback**:
- POST /api/feedback (public)
- GET /api/feedback/recent (authenticated)
- GET /api/feedback/:id (authenticated)
- DELETE /api/feedback/:id (authenticated)

**Analytics**:
- GET /api/analytics/overview
- GET /api/analytics/journeys-advanced
- GET /api/analytics/export

**User**:
- GET /api/user/profile
- PUT /api/user/profile
- PUT /api/user/settings
- DELETE /api/user/account

**Widgets**:
- GET /api/widgets
- POST /api/widgets
- PUT /api/widgets/:id
- DELETE /api/widgets/:id

**Subscriptions**:
- POST /api/stripe/create-checkout-session
- POST /api/stripe/webhook
- GET /api/stripe/subscription
- POST /api/stripe/cancel

---

**Documento Version**: 1.0
**Last Updated**: 2026-03-18
**Next Review**: 2026-06-18
**Maintained By**: Feedback Widget Development Team
