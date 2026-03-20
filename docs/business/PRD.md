# PRD - Product Requirements Document
## Feedback Widget SaaS

**Versión**: 1.0
**Fecha**: Marzo 2026
**Status**: En Desarrollo
**Product Owner**: Feedback Widget Team

---

## 1. Executive Summary

Feedback Widget SaaS es una plataforma SaaS multi-tenant que permite a sitios web recolectar feedback de usuarios mediante un widget emoji no invasivo, respetando la privacidad del usuario (sin cookies ni tracking). Se posiciona como una solución privacy-first, API-first y AI-ready para recolección de feedback continua.

### Visión del Producto
Ser la solución líder en recolección de feedback privacy-first, permitiendo a empresas entender a sus usuarios sin comprometer la privacidad, con capacidades avanzadas de análisis y acción sobre el feedback.

### Misión
Democratizar el acceso a herramientas de feedback enterprise-grade con enfoque en privacidad, cumplimiento GDPR y simplicidad de implementación.

---

## 2. Problem Statement

### Problemas del Mercado

1. **Invasión de Privacidad**: Las herramientas actuales de feedback dependen excesivamente de cookies, fingerprinting y tracking invasivo.
2. **Complejidad de Implementación**: Soluciones enterprise requieren equipos técnicos dedicados para integración.
3. **Costos Prohibitivos**: Herramientas quality-first son costosas, con planes complejos y locks-in contractuales.
4. **Falta de Actionability**: Mucho feedback se recolecta pero poco se actúa sobre él debido a falta de insights procesables.
5. **Non-Compliance GDPR**: Muchas herramientas no cumplen estándares de privacidad europeos.

### Usuarios Afectados

- **Small Business Owners**: Necesitan feedback pero no tienen recursos técnicos
- **Product Managers**: Requieren insights rápidos sin implementaciones complejas
- **SaaS Companies**: Necesitan feedback continuo sin afectar UX negativamente
- **E-commerce**: Quieren entender customer journey sin invasión de privacidad
- **Agencias Digitales**: Gestionan múltiples clientes y necesitan solución white-label

### Necesidades No Resueltas

1. Herramienta simple de implementar (una línea de JS)
2. Privacy-first (sin cookies ni tracking)
3. Insights procesables (no solo datos crudos)
4. Pricing transparente y predecible
5. API access para integraciones custom
6. Multi-tenant para agencias y empresas multi-site

---

## 3. Solution Overview

### Propuesta de Valor

**Feedback Widget SaaS** ofrece una solución de feedback emoji-based que:
- Respecta la privacidad (cookie-free, tracking-free)
- Se implementa en 5 minutos (un script tag)
- Proporciona insights procesables (analytics con journey tracking)
- Integra con herramientas existentes (webhooks, Slack, Discord)
- Ofrece API completa para customizaciones
- Cumpla GDPR por diseño

### Diferenciadores Clave

| Feature | Feedback Widget | Competitors |
|---------|----------------|-------------|
| Privacy-First | ✅ Sin cookies ni tracking | ❌ Cookies/fingerprinting |
| Implementation | ✅ 5 minutos, 1 línea | ⚠️ 30+ minutos, configuración |
| Pricing | ✅ Transparente, mensual | ⚠️ Complejo, anual |
| API Access | ✅ Disponible en plan Growth | ❌ Solo enterprise |
| Journey Tracking | ✅ SPA navigation nativo | ⚠️ Limitado o manual |
| GDPR Compliance | ✅ Por diseño | ⚠️ Requiere configuración |

### Target Market

#### Primary Market (70% del foco)
- **SaaS B2B**: $1M-$50M ARR, needing continuous user feedback
- **E-commerce**: Online stores optimizando customer experience
- **Digital Products**: Courses, memberships, subscriptions

#### Secondary Market (20% del foco)
- **Digital Agencies**: Managing multiple client sites
- **Product Teams**: In companies $50M-$500M revenue

#### Tertiary Market (10% del foco)
- **Enterprise**: Large organizations needing white-label solutions

---

## 4. Product Requirements

### Core Features (MVP)

#### 4.1 Feedback Collection
**FR-001: Widget Installation**
- User puede copiar script tag único
- Widget se auto-inicializa
- SoportaSingle Page Applications
- Cookie-free operation
- Mobile responsive

**FR-002: Feedback Options**
- 4 emoji options (😀 😐 😡 🚫)
- Optional comment box (max 1000 chars)
- Contextual journey tracking
- Metadata automática (userAgent, language, platform, referrer)

**FR-003: Customization**
- Widget position (4 corners)
- Theme selection (light/dark)
- Color customization
- Trigger timing options

#### 4.2 Analytics & Reporting
**FR-004: Real-time Dashboard**
- Total feedback count
- Average rating
- Rating distribution
- Recent feedback feed
- Date range filtering

**FR-005: Journey Analytics**
- User journey visualization
- Top pages by feedback
- Path analysis (page transitions)
- Time on page analysis
- Drop-off points identification

**FR-006: Export & Reporting**
- CSV export
- JSON export
- Weekly email digests
- Custom date range reports

#### 4.3 User Management
**FR-007: Authentication**
- Email/password authentication
- Password reset flow
- JWT-based sessions
- Remember me functionality

**FR-008: Profile Management**
- Profile settings (name, email, avatar)
- Password change
- Email preferences
- Account deletion

**FR-009: Multi-Widget Support**
- Create multiple widgets
- Widget-specific settings
- Widget switching in dashboard
- Per-widget analytics

#### 4.4 Integration Capabilities
**FR-010: Webhooks**
- Custom webhook endpoints
- Real-time notifications
- Retry logic
- Event filtering

**FR-011: Third-Party Integrations**
- Slack notifications
- Discord notifications
- Email notifications
- Zapier integration

**FR-012: API Access**
- RESTful API
- API key management
- Rate limiting per API key
- API documentation (Swagger UI)

### Advanced Features (Post-MVP)

#### 4.5 AI-Powered Insights
**FR-013: Sentiment Analysis**
- Automatic sentiment detection
- Trend identification
- Anomaly detection
- Smart categorization

**FR-014: Actionable Recommendations**
- Suggested improvements
- Priority scoring
- Impact analysis
- A/B test suggestions

#### 4.6 Advanced Analytics
**FR-015: Cohort Analysis**
- User cohorts by behavior
- Retention analysis
- Churn prediction
- Lifetime value estimation

**FR-016: Funnel Analysis**
- Conversion funnels
- Drop-off analysis
- Bottleneck identification
- Optimization suggestions

#### 4.7 Collaboration Features
**FR-017: Team Access**
- Team member invitations
- Role-based access control
- Activity feed
- Comment threads on feedback

**FR-018: Custom Dashboards**
- Drag-and-drop widgets
- Custom chart types
- Dashboard templates
- Scheduled reports

### Non-Functional Requirements

#### NFR-001: Performance
- Widget load time < 1s
- API response time < 200ms (p95)
- Dashboard load time < 2s
- Support 10,000 concurrent users

#### NFR-002: Security
- OWASP Top 10 compliance
- GDPR compliant by design
- SOC 2 Type II certified (target)
- Regular security audits
- Penetration testing

#### NFR-003: Reliability
- 99.9% uptime SLA
- Auto-scaling infrastructure
- Disaster recovery plan
- Daily backups
- Multi-region deployment

#### NFR-004: Usability
- Time-to-first-widget < 5 minutes
- No technical knowledge required
- Intuitive dashboard navigation
- Mobile-responsive design
- WCAG 2.1 AA compliance

#### NFR-005: Scalability
- Support 1M+ feedback records per day
- Horizontal scaling capability
- Database sharding ready
- CDN distribution
- Edge computing ready

---

## 5. User Stories

### Epic 1: Onboarding
**US-001: Quick Start**
```
Como nuevo usuario,
Quiero tener mi widget funcionando en menos de 5 minutos,
Para empezar a recolectar feedback inmediatamente
```

**Acceptance Criteria:**
- User puede copiar script tag en < 30 segundos
- Widget funciona sin configuración adicional
- Tutorial interactivo disponible
- First feedback recibido en < 5 minutos

### Epic 2: Analytics
**US-002: Journey Insights**
```
Como product manager,
Quiero ver el journey completo de usuarios antes de dar feedback,
Para identificar fricciones y mejorar experiencia
```

**Acceptance Criteria:**
- Journey visualization disponible
- Path analysis entre páginas
- Time on page tracking
- Drop-off points identificados

### Epic 3: Integrations
**US-003: Real-time Notifications**
```
Como customer support lead,
Quiero recibir notificaciones en Slack de feedback negativo,
Para responder proactivamente y retener clientes
```

**Acceptance Criteria:**
- Slack webhook integration funcional
- Filtro por rating (solo negativos)
- Customizable message format
- < 30 segundos延迟

### Epic 4: Multi-Site Management
**US-004: Agency Dashboard**
```
Como agencia digital,
Quiero gestionar múltiples clientes desde un dashboard,
Para ahorrar tiempo y mantener oversight
```

**Acceptance Criteria:**
- Crear widgets ilimitados
- Switch entre widgets
- Per-widget analytics
- Client branding (white-label)

---

## 6. Technical Architecture

### System Overview
```
┌─────────────────────────────────────────────────────────────┐
│                     Client Websites                         │
│                  (Widget JavaScript)                        │
└────────────────────┬────────────────────────────────────────┘
                     │ HTTPS POST
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   CDN / Edge Layer                          │
│              (Widget Distribution)                          │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  API Gateway                                │
│            (Rate Limiting, Auth)                            │
└────────────────────┬────────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         ▼                       ▼
┌────────────────┐      ┌────────────────┐
│  Application   │      │   Database      │
│    Server      │◄────►│   (MongoDB)     │
│  (Node.js)     │      │                │
└────────┬───────┘      └────────────────┘
         │
    ┌────┴────┬────────┬──────────┐
    ▼         ▼        ▼          ▼
┌────────┐ ┌──────┐ ┌─────┐ ┌─────────┐
│Stripe  │ │Email │ │Web  │ │Analytics│
│        │ │Service│ │hooks│ │Service  │
└────────┘ └──────┘ └─────┘ └─────────┘
```

### Technology Stack
- **Frontend Widget**: Vanilla JavaScript, Webpack
- **Dashboard**: Next.js 14, React 18, Tailwind CSS, shadcn/ui
- **Backend**: Node.js, Express.js
- **Database**: MongoDB Atlas
- **Payments**: Stripe
- **Email**: SendGrid
- **CDN**: Cloudflare
- **Hosting**: Vercel (Landing), Coolify (Backend)

---

## 7. Data Model

### Core Entities

#### User
```javascript
{
  _id: ObjectId,
  email: String (unique, required),
  password: String (hashed, required),
  plan: Enum ['free', 'starter', 'growth', 'agency'],
  stripeCustomerId: String,
  stripeSubscriptionId: String,
  settings: {
    emailNotifications: Boolean,
    weeklyDigest: Boolean,
    timezone: String,
    language: String
  },
  createdAt: Date,
  updatedAt: Date
}
```

#### Widget
```javascript
{
  _id: ObjectId,
  userId: ObjectId (ref: User),
  name: String,
  domain: String,
  settings: {
    position: Enum ['bottom-right', 'bottom-left', 'top-right', 'top-left'],
    theme: Enum ['light', 'dark'],
    primaryColor: String,
    triggerDelay: Number,
    allowAnonymous: Boolean
  },
  status: Enum ['active', 'paused', 'archived'],
  createdAt: Date,
  updatedAt: Date
}
```

#### Feedback
```javascript
{
  _id: ObjectId,
  widgetId: ObjectId (ref: Widget),
  userId: ObjectId (ref: User),
  sessionId: String,
  rating: Number (1-4, required),
  comment: String (max 1000),
  journey: [{
    path: String,
    timestamp: Number,
    referrer: String
  }],
  metadata: {
    userAgent: String,
    language: String,
    platform: String,
    screenResolution: String,
    viewport: String,
    timezone: String
  },
  url: String,
  sentiment: Enum ['positive', 'neutral', 'negative'],
  categories: [String],
  status: Enum ['new', 'reviewed', 'archived'],
  createdAt: Date,
  updatedAt: Date
}
```

---

## 8. Success Metrics

### North Star Metric
**Weekly Active Widgets (WAW)**: Number of widgets that received at least one feedback in the last 7 days.

### Key Performance Indicators

#### Acquisition
- **Sign-up Rate**: Visitors → Sign-ups
- **Activation Rate**: Sign-ups → First-widget-installed
- **Time-to-Value**: Time from sign-up to first feedback
- **CAC by Channel**: Customer acquisition cost

#### Engagement
- **DAU/WAU**: Daily/Weekly Active Users
- **Feedback per Widget**: Average feedback per widget per week
- **Dashboard Visits**: Frequency of dashboard access
- **Feature Adoption**: Usage of advanced features

#### Retention
- **Week 1 Retention**: % users active after 7 days
- **Week 4 Retention**: % users active after 30 days
- **Churn Rate**: Monthly cancellation rate
- **Expansion Revenue**: Upgrade rate (free → paid, plan upgrades)

#### Revenue
- **MRR**: Monthly Recurring Revenue
- **ARPU**: Average Revenue Per User
- **LTV**: Customer Lifetime Value
- **LTV:CAC Ratio**: Lifetime value vs acquisition cost

### Quality Metrics
- **Widget Uptime**: % time widget is accessible
- **API Response Time**: p50, p95, p99 latency
- **Error Rate**: % failed requests
- **Customer Satisfaction**: CSAT/NPS scores

---

## 9. Go-to-Market Strategy

### Phase 1: Early Adopters (Months 1-3)
**Target**: First 100 users
- **Offer**: 50% lifetime discount
- **Price**: One-time payment option
- **Goal**: Validate product-market fit
- **Channels**: Direct outreach, beta communities

### Phase 2: Launch (Months 4-6)
**Target**: First 1,000 users
- **Offer**: Standard pricing with 14-day trial
- **Price**: Monthly/annual subscriptions
- **Goal**: Scale acquisition
- **Channels**: Content marketing, SEO, Product Hunt

### Phase 3: Growth (Months 7-12)
**Target**: 5,000 users
- **Offer**: Feature expansion, integrations
- **Price**: Tiered pricing with API access
- **Goal**: Market expansion
- **Channels**: Paid ads, partnerships, referrals

### Phase 4: Scale (Year 2+)
**Target**: 20,000+ users
- **Offer**: Enterprise features, white-label
- **Price**: Custom enterprise pricing
- **Goal**: Market leadership
- **Channels**: Sales team, enterprise partnerships

---

## 10. Competitive Analysis

### Direct Competitors

| Feature | Feedback Widget | Hotjar | UserVoice | Typeform |
|---------|----------------|--------|-----------|----------|
| Privacy-First | ✅ | ❌ | ⚠️ | ⚠️ |
| Emoji Widget | ✅ | ❌ | ❌ | ✅ |
| Journey Tracking | ✅ | ✅ | ❌ | ❌ |
| API Access | ✅ (Growth) | ❌ (Enterprise) | ⚠️ | ✅ |
| Pricing | Transparent | Complex | Complex | Complex |
| GDPR Compliance | ✅ | ⚠️ | ⚠️ | ✅ |

### Competitive Advantages
1. **Privacy-by-Design**: Only truly privacy-first solution
2. **Implementation Speed**: 5 minutes vs hours/days
3. **Transparent Pricing**: Simple, predictable pricing
4. **API Access**: Available in mid-tier, not enterprise
5. **Journey Intelligence**: Advanced SPA tracking out-of-the-box

---

## 11. Risk Assessment

### Technical Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Widget blocking by ad-blockers | High | Medium | Provide CDN distribution, allowlist instructions |
| Browser compatibility issues | Medium | Low | Progressive enhancement, extensive testing |
| Scaling bottlenecks | High | Low | Auto-scaling, caching, load testing |
| Data loss | Critical | Low | Daily backups, multi-region replication |

### Business Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Low adoption rate | High | Medium | Free tier, viral mechanics, exceptional onboarding |
| Competitor copying | Medium | High | Fast iteration, brand building, moat through data |
| Pricing pressure | Medium | Medium | Value-based pricing, unique features |
| Churn rate too high | High | Medium | Exceptional support, continuous value delivery |

### Legal Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| GDPR non-compliance | Critical | Low | Privacy-by-design, legal review, DPAs |
| Data breach | Critical | Low | Security audits, penetration testing, encryption |
| IP infringement | High | Low | Patent search, original development, legal review |

---

## 12. Roadmap

### Q2 2026: MVP Launch
- Week 1-2: Security fixes
- Week 3-4: Testing & Quality
- Week 5-6: Core features completion
- Week 7-8: Documentation & Launch

### Q3 2026: Growth Features
- Multi-widget support
- Advanced analytics
- Notification system
- API access (Growth plan)

### Q4 2026: Advanced Features
- AI-powered insights
- Custom dashboards
- White-label options
- Mobile apps (iOS/Android)

### Q1 2027: Enterprise
- Team collaboration
- Advanced integrations
- Single Sign-On (SSO)
- Custom contracts

---

## 13. Definitions

**Active Widget**: Widget that has received at least one feedback in the last 30 days.

**Session**: Unique user visit identified by session ID, tracking pages visited before feedback.

**Journey**: Complete path of pages a user visited on a website before providing feedback.

**Sentiment**: Emotional tone of feedback (positive/neutral/negative) determined by AI analysis.

**Widget ID**: Unique identifier for each widget instance, used for script installation and data association.

---

## 14. Appendices

### Appendix A: User Personas

**Persona 1: Sarah - SaaS Founder**
- Age: 28-35
- Role: Founder/CEO of B2B SaaS ($1-5M ARR)
- Goals: Understand user pain points, improve retention
- Technical level: Medium
- Pain points: Tools too complex, invasive, expensive

**Persona 2: Marco - E-commerce Owner**
- Age: 30-45
- Role: Owner of online store (10-50 employees)
- Goals: Optimize customer experience, increase conversions
- Technical level: Low to Medium
- Pain points: Need simple implementation, clear ROI

**Persona 3: Lisa - Digital Agency Manager**
- Age: 25-35
- Role: Managing multiple client websites
- Goals: Provide value to clients, scale agency services
- Technical level: High
- Pain points: White-label solutions, multi-client management

### Appendix B: Technical Constraints
- Must be cookie-free for GDPR compliance
- Widget size < 20KB minified
- Support IE11+ (fallback), modern browsers fully
- Mobile-first responsive design
- CDN distribution for global performance

### Appendix C: Assumptions
- Users have basic web development knowledge
- Target markets have GDPR/privacy concerns
- Email delivery is reliable (SendGrid SLA)
- Stripe maintains 99.99% uptime
- MongoDB Atlas scaling capabilities

---

**Document Version**: 1.0
**Last Updated**: 2026-03-18
**Next Review**: 2026-04-18
**Approved By**: Feedback Widget Team
