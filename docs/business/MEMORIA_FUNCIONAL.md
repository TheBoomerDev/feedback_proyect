# MEMORIA FUNCIONAL
## Feedback Widget SaaS

**Versión**: 1.0
**Fecha**: Marzo 2026
**Status**: En Desarrollo
**Product Owner**: Feedback Widget Team

---

## 1. Introducción

### 1.1 Propósito del Documento

Esta memoria funcional describe el comportamiento del sistema Feedback Widget SaaS desde la perspectiva del usuario, incluyendo casos de uso, requerimientos funcionales, flujos de usuario y especificaciones de la interfaz.

### 1.2 Audiencia Objetivo

- **Product Managers**: Para entender las funcionalidades del producto
- **Diseñadores UX/UI**: Para diseñar interfaces consistentes
- **Desarrolladores**: Para implementar las funcionalidades correctamente
- **QA/Tester**: Para crear casos de prueba
- **Stakeholders**: Para entender qué hace el producto

---

## 2. Descripción General del Sistema

### 2.1 Objetivo del Sistema

Feedback Widget SaaS es una plataforma que permite a los propietarios de sitios web recolectar feedback de sus usuarios de manera no invasiva, respetando la privacidad (sin cookies ni tracking), proporcionando insights procesables para mejorar la experiencia del usuario.

### 2.2 Usuarios del Sistema

#### Usuario Primario: Site Owner
- **Perfil**: Dueño de sitio web, product manager, founder
- **Objetivos**: Recolectar feedback, entender usuarios, mejorar producto
- **Skills Técnicos**: Básicos a intermedios (sabe copiar/pegar código)
- **Frecuencia de Uso**: Diaria (dashboard analytics)

#### Usuario Secundario: Team Member
- **Perfil**: Miembro de equipo con acceso limitado
- **Objetivos**: Ver feedback, responder a usuarios, generar reportes
- **Skills Técnicos**: Variables
- **Frecuencia de Uso**: Semanal

#### Usuario Terciario: Agency Manager
- **Perfil**: Gestiona múltiples clientes
- **Objetivos**: Gestionar widgets de múltiples clientes, reporting
- **Skills Técnicos**: Intermedios a avanzados
- **Frecuencia de Uso**: Diaria

#### Usuario Final: Website Visitor
- **Perfil**: Visitante del sitio que da feedback
- **Objetivos**: Expresar opinión rápida y fácilmente
- **Skills Técnicos**: Ninguno requerido
- **Frecuencia de Uso**: Única (cuando desea dar feedback)

---

## 3. Casos de Uso

### 3.1 Diagrama de Casos de Uso

```
┌─────────────────────────────────────────────────────────────┐
│                    FEEDBACK WIDGET SaaS                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Site Owner   │  │ Team Member  │  │Agency Manager│    │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘    │
│         │                 │                 │             │
│         └─────────────────┴─────────────────┘             │
│                           │                               │
│    ┌──────────────────────┼──────────────────────┐      │
│    │                      │                      │      │
│    ▼                      ▼                      ▼      │
│ ┌─────────┐         ┌─────────┐         ┌─────────┐ │
│ │ Register│         │  Login  │         │ Manage  │ │
│ │ Account │         │         │         │ Widgets │ │
│ └─────────┘         └─────────┘         └─────────┘ │
│    │                    │                    │         │
│    ▼                    ▼                    ▼         │
│ ┌─────────┐         ┌─────────┐         ┌─────────┐ │
│ │ Install │         │ View    │         │Configure│ │
│ │ Widget  │         │Feedback │         │Settings │ │
│ └─────────┘         └─────────┘         └─────────┘ │
│    │                    │                    │         │
│    ▼                    ▼                    ▼         │
│ ┌─────────┐         ┌─────────┐         ┌─────────┐ │
│ │ View    │         │ Export  │         │ Manage  │ │
│ │Analytics│         │  Data   │         │ Integr'n│ │
│ └─────────┘         └─────────┘         └─────────┘ │
│                                                                │
│  ┌──────────────┐                                            │
│  │Website Visitor│                                           │
│  └──────┬───────┘                                            │
│         │                                                    │
│         ▼                                                    │
│    ┌─────────┐                                               │
│    │  Give   │                                               │
│    │Feedback │                                               │
│    └─────────┘                                               │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Descripción de Casos de Uso

#### UC-001: Registro de Usuario
**Actor**: Site Owner
**Precondiciones**:
- Usuario tiene email válido
- Usuario acepta términos y condiciones

**Flujo Principal**:
1. Usuario accede a /register
2. Sistema muestra formulario de registro
3. Usuario ingresa:
   - Email (válido, único)
   - Password (mínimo 12 caracteres, complexity check)
   - Nombre (opcional)
4. Sistema valida datos
5. Sistema crea cuenta con plan Free
6. Sistema envía email de verificación
7. Sistema redirige a dashboard
8. Sistema muestra onboarding tutorial

**Postcondiciones**:
- Cuenta creada en sistema
- Usuario autenticado
- Widget ID generado
- Dashboard accesible

**Flujos Alternativos**:
- **3a**: Email ya existe → Sistema muestra error, sugiere login
- **3b**: Password muy débil → Sistema muestra requisitos, pide reingresar
- **3c**: Validación falla → Sistema muestra errores específicos por campo

#### UC-002: Instalación de Widget
**Actor**: Site Owner
**Precondiciones**:
- Usuario autenticado
- Usuario tiene acceso al código de su sitio

**Flujo Principal**:
1. Usuario accede a sección "Widgets" en dashboard
2. Usuario selecciona "Crear nuevo widget" o usa widget default
3. Sistema muestra código de instalación:
   ```html
   <script src="https://cdn.feedbackwidget.com/widget.js"
           data-widget-id="WIDGET_ID"
           async></script>
   ```
4. Usuario copia código
5. Usuario pega código en su sitio web (antes de </body>)
6. Sistema muestra guía de instalación paso a paso
7. Sistema muestra estado de verificación
8. Widget se activa y comienza a recolectar feedback

**Postcondiciones**:
- Widget instalado en sitio del usuario
- Sistema recibe feedback de visitantes
- Dashboard muestra estadísticas en tiempo real

**Flujos Alternativos**:
- **6a**: Usuario no sabe dónde pegar código → Sistema muestra tutorial interactivo
- **7a**: Widget no detecta tráfico → Sistema muestra troubleshooting steps

#### UC-003: Visualización de Analytics
**Actor**: Site Owner
**Precondiciones**:
- Usuario autenticado
- Widget instalado y recibiendo feedback

**Flujo Principal**:
1. Usuario accede a dashboard
2. Sistema muestra overview con:
   - Total feedback (últimos 30 días)
   - Rating promedio
   - Distribución de ratings (gráfico de barras)
   - Top journeys (top 5)
   - Feedback reciente (últimos 10)
3. Usuario puede filtrar por rango de fechas
4. Usuario puede cambiar widget selector
5. Sistema actualiza datos en tiempo real

**Postcondiciones**:
- Usuario tiene visión completa de feedback recibido
- Usuario puede identificar tendencias y patrones

**Flujos Alternativos**:
- **2a**: No hay feedback aún → Sistema muestra estado "Esperando primer feedback"
- **3a**: Rango de fechas sin datos → Sistema muestra mensaje "No hay datos en este periodo"

#### UC-004: Gestión de Widgets
**Actor**: Site Owner, Agency Manager
**Precondiciones**:
- Usuario autenticado
- Plan permite múltiples widgets (Growth/Agency)

**Flujo Principal**:
1. Usuario accede a sección "Widgets"
2. Sistema muestra lista de widgets del usuario
3. Usuario puede:
   - Crear nuevo widget
   - Editar configuración existente
   - Archivar widget
   - Eliminar widget
4. Para crear: Usuario ingresa nombre, dominio, configuración
5. Sistema genera nuevo widget ID
6. Sistema muestra código de instalación

**Postcondiciones**:
- Gestión centralizada de múltiples widgets
- Configuración independiente por widget

#### UC-005: Exportación de Datos
**Actor**: Site Owner
**Precondiciones**:
- Usuario autenticado
- Hay feedback disponible para exportar

**Flujo Principal**:
1. Usuario accede a sección "Analytics"
2. Usuario selecciona "Exportar datos"
3. Sistema muestra formulario de exportación:
   - Rango de fechas
   - Rating filter (opcional)
   - Formato (CSV, JSON, XLSX)
   - Incluir comentarios (checkbox)
4. Usuario configura filtros deseados
5. Usuario confirma exportación
6. Sistema genera archivo
7. Sistema inicia descarga automática
8. Sistema envía email confirmación con link de descarga

**Postcondiciones**:
- Usuario tiene datos exportados para análisis offline

---

## 4. Requerimientos Funcionales Detallados

### 4.1 Módulo de Autenticación

#### RF-001: Registro de Usuario
**Descripción**: Sistema debe permitir registro de nuevos usuarios con email y password.

**Requerimientos**:
- Email debe ser válido y único en sistema
- Password mínimo 12 caracteres
- Password debe contener: mayúscula, minúscula, número, símbolo
- Confirmación de password obligatoria
- Aceptación de términos y condiciones obligatoria
- Email de verificación enviado post-registro

**Validaciones**:
```javascript
{
  email: {
    required: true,
    format: 'email',
    unique: true
  },
  password: {
    required: true,
    minLength: 12,
    strength: 'strong'  // Must contain uppercase, lowercase, number, symbol
  },
  confirmPassword: {
    required: true,
    match: 'password'
  },
  terms: {
    required: true,
    accept: true
  }
}
```

#### RF-002: Inicio de Sesión
**Descripción**: Sistema debe autenticar usuarios con credenciales válidas.

**Requerimientos**:
- Email + password authentication
- Opción "Remember me" (7 días)
- Mensajes de error claros (sin revelar si email existe)
- Rate limiting: 5 intentos por 15 minutos
- Account lockout temporal tras 5 intentos fallidos

#### RF-003: Recuperación de Password
**Descripción**: Sistema debe permitir recuperación de contraseña vía email.

**Requerimientos**:
- Usuario ingresa email
- Sistema envía email con token de reset (válido 1 hora)
- Usuario crea nuevo password
- Token se invalida post-uso
- Notificación de cambio de password

### 4.2 Módulo de Widget

#### RF-004: Configuración de Widget
**Descripción**: Usuario debe poder configurrar apariencia y comportamiento del widget.

**Opciones de Configuración**:
- **Posición**: bottom-right, bottom-left, top-right, top-left
- **Tema**: light, dark
- **Color primario**: Selector de color o código hex
- **Trigger delay**: Segundos antes de mostrar widget (0-30)
- **Permitir anónimos**: Toggle para permitir feedback sin login
- **Mostrar en móviles**: Responsive toggle

#### RF-005: Instalación de Widget
**Descripción**: Sistema debe proporcionar código simple de instalación.

**Código Proporcionado**:
```html
<script src="https://cdn.feedbackwidget.com/widget.js"
        data-widget-id="WIDGET_ID"
        data-position="bottom-right"
        data-theme="light"
        async></script>
```

**Características**:
- Single script tag
- Configuración vía data attributes
- Async loading para no bloquear render
- Auto-initialization

#### RF-006: Comportamiento del Widget
**Descripción**: Widget debe comportarse de manera no invasiva.

**Comportamiento**:
- No aparece en primera visita (opcional)
- Se minimiza después de feedback dado
- No bloquea navegación
- Mobile responsive
- Accessible (keyboard navigation)
- WCAG 2.1 AA compliant

### 4.3 Módulo de Feedback

#### RF-007: Recolección de Feedback
**Descripción**: Widget debe recolectar feedback de manera simple.

**Campos del Formulario**:
- 4 opciones de emoji (😀 😐 😡 🚫)
- Campo de comentario opcional (max 1000 caracteres)
- Submit button

**Metadata Automática**:
- Session ID (generado aleatoriamente)
- URL actual
- User agent
- Language
- Platform
- Screen resolution
- Referrer
- Timestamp

#### RF-008: Journey Tracking
**Descripción**: Sistema debe rastrear navegación del usuario antes de feedback.

**Datos Capturados**:
- Path de cada página visitada
- Timestamp de cada visita
- Referrer entre páginas
- Tiempo en cada página

**SPA Support**:
- Auto-detecta cambios de URL en SPAs
- No requiere configuración adicional
- Funciona con React Router, Vue Router, Angular

### 4.4 Módulo de Analytics

#### RF-009: Dashboard Overview
**Descripción**: Dashboard debe mostrar métricas clave de feedback.

**Métricas Mostradas**:
- Total feedback (período seleccionado)
- Rating promedio
- Distribución de ratings (gráfico)
- Tendencia temporal (gráfico de línea)
- Top 5 journeys
- Feedback reciente (feed)

**Filtros Disponibles**:
- Rango de fechas (preset: 7d, 30d, 90d, custom)
- Selector de widget
- Rating filter (all, positive, neutral, negative)

#### RF-010: Journey Analytics
**Descripción**: Sistema debe mostrar análisis del journey del usuario.

**Visualizaciones**:
- Journey flow diagram (sankey diagram)
- Top páginas por feedback
- Path transitions (probabilidades)
- Tiempo promedio por página
- Drop-off points

**Insights**:
- Páginas con más feedback negativo
- Common paths antes de feedback negativo
- Páginas con mayor engagement

#### RF-011: Exportación de Datos
**Descripción**: Usuario debe poder exportar datos de feedback.

**Formatos Soportados**:
- CSV (para Excel, Google Sheets)
- JSON (para integraciones)
- XLSX (Excel nativo)

**Filtros de Exportación**:
- Rango de fechas
- Rating filter
- Include/exclude comments
- Widget selector

**Límites**:
- Free plan: Últimos 30 días
- Starter: Últimos 90 días
- Growth/Agency: Todos los tiempos

### 4.5 Módulo de Integraciones

#### RF-012: Webhooks
**Descripción**: Sistema debe permitir notificaciones webhook en tiempo real.

**Eventos Disponibles**:
- feedback.received
- feedback.flagged (comentario negativo)
- usage.limit_reached

**Configuración**:
- URL del endpoint
- Secret key para firma
- Event filter (qué eventos enviar)
- Retry policy (3 reintentos con exponential backoff)

#### RF-013: Slack Integration
**Descripción**: Sistema debe enviar notificaciones a Slack.

**Configuración**:
- Webhook URL de Slack
- Canal o DM destination
- Event filter
- Message template customizado

**Formato de Mensaje**:
```
🚨 New Negative Feedback
Rating: 😡
Comment: "No puedo encontrar el botón de checkout"
Journey: /home → /products → /checkout
URL: example.com/products
```

#### RF-014: Discord Integration
**Descripción**: Sistema debe enviar notificaciones a Discord.

**Similar a Slack**, con adaptaciones para Discord webhooks.

### 4.6 Módulo de API

#### RF-015: REST API Access
**Descripción**: Sistema debe exponer API REST para desarrolladores.

**Disponible en**: Plan Growth y Agency

**Endpoints Principales**:
- GET /api/feedback - Listar feedback
- GET /api/feedback/:id - Obtener feedback específico
- POST /api/feedback - Crear feedback
- GET /api/analytics/overview - Analytics overview
- GET /api/widgets - Listar widgets
- POST /api/widgets - Crear widget

**Autenticación**:
- API Key en header: `X-API-Key: your_api_key`
- Rate limiting por API key
- Permisos scope por key

---

## 5. Especificaciones de Interfaz

### 5.1 Dashboard Principal

**Layout**:
```
┌─────────────────────────────────────────────────────────┐
│  Logo    Dashboard    Analytics    Widgets    Settings  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Welcome back, [Name]!                    [User Avatar]  │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐│
│  │   Total      │  │   Average    │  │  This Week   ││
│  │  Feedback    │  │   Rating     │  │    vs Last   ││
│  │   1,234      │  │    3.7       │  │    +12%      ││
│  └──────────────┘  └──────────────┘  └──────────────┘│
│                                                          │
│  Rating Distribution                    Recent Feedback │
│  ┌──────────────────────────────────┐  ┌─────────────┐│
│  │ 😀 ████████████████████ 45%     │  │ • "Great!"   ││
│  │ 😐 ████████████ 25%             │  │   😀 2h ago  ││
│  │ 😡 ████████ 20%                 │  │             ││
│  │ 🚫 ███ 10%                      │  │ • "Confused" ││
│  └──────────────────────────────────┘  │   😐 5h ago  ││
│                                        └─────────────┘│
│  Top Journeys                                        │
│  ┌──────────────────────────────────────────────┐   │
│  │ 1. /home → /products → /checkout (23)      │   │
│  │ 2. /home → /about (15)                      │   │
│  │ 3. /products → /product/123 (12)           │   │
│  └──────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### 5.2 Widget de Feedback

**Apariencia**:
```
┌─────────────────────────┐
│  How was your experience?│
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐│
│  │ 😀│ │ 😐│ │ 😡│ │ 🚫││
│  └───┘ └───┘ └───┘ └───┘│
│                         │
│  [Add comment...]      │
│                         │
│  [Send Feedback]       │
│  [✕]                   │
└─────────────────────────┘
```

**Posicionamiento**:
- Bottom-right (default)
- Bottom-left
- Top-right
- Top-left

**Comportamiento**:
- Fade in appearance (2s delay default)
- Minimize después de feedback
- Click en icono para maximizar
- Close button disponible

### 5.3 Formulario de Configuración

**Settings Form**:
```
┌─────────────────────────────────────────────────────────┐
│  Widget Settings                                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Widget Name                                             │
│  [My Awesome Widget                          ]          │
│                                                          │
│  Domain                                                 │
│  [https://example.com                       ]          │
│                                                          │
│  Position                   Theme                         │
│  ○ Bottom-right    ○ ○ Light  ○ Dark                   │
│  ○ Bottom-left                                         │
│  ○ Top-right                                           │
│  ○ Top-left                                            │
│                                                          │
│  Primary Color                                         │
│  [🎨 #3B82F6                                ]          │
│                                                          │
│  Trigger Delay (seconds)                                │
│  [━━━━○━━━] 2                                          │
│                                                          │
│  ☑ Allow anonymous feedback                            │
│  ☑ Show on mobile devices                               │
│                                                          │
│  [Cancel]                               [Save Changes] │
└─────────────────────────────────────────────────────────┘
```

---

## 6. Reglas de Negocio

### 6.1 Límites de Uso por Plan

| Feature | Free | Starter | Growth | Agency |
|---------|-------|---------|--------|--------|
| Feedback/mes | 250 | 10,000 | 50,000 | Unlimited |
| Widgets | 1 | 3 | 10 | Unlimited |
| Analytics días | 7 | 30 | 90 | All |
| Export | Last 30d | Last 90d | All | All |
| API Access | ❌ | ❌ | ✅ | ✅ |
| Webhooks | ❌ | ✅ 3 | ✅ 10 | ✅ Unlimited |
| White-label | ❌ | ❌ | ❌ | ✅ |
| Team Members | 1 | 3 | 10 | Unlimited |

### 6.2 Políticas de Retención de Datos

**Feedback Data**:
- Free plan: 30 días
- Starter: 90 días
- Growth/Agency: 1 año

**Account Deletion**:
- Inmediata tras solicitud
- Todos los datos eliminados en 30 días
- Export disponible antes de eliminación

### 6.3 Políticas de Suspensión

**Uso Excedido**:
- Notificación por email al 80% del límite
- Suspensión temporal al 100%
- Reactivación al inicio de nuevo mes o upgrade

**Violación de TOS**:
- Warning primera vez
- Suspensión 7 días segunda vez
- Terminación tercera vez

---

## 7. Flujos de Usuario Detallados

### 7.1 Flujo de Onboarding

```
Start → Register → Email Verification → Dashboard
                                     →
                           Create Widget → Install Code
                                     →
                           Wait for Feedback → View Analytics
                                     →
                                Explore Features → End
```

**Onboarding Checklist**:
- [x] Account created
- [x] Email verified
- [x] Widget created
- [x] Code installed
- [x] First feedback received
- [x] Analytics viewed

### 7.2 Flujo de Upgrade

```
Dashboard → Click "Upgrade" → Select Plan
                                    →
                              Enter Payment → Confirm
                                    →
                          Subscription Activated → Features Unlocked
                                    →
                                 Confirmation Email
```

### 7.3 Flujo de Feedback Negativo

```
User gives negative rating → Webhook triggered (if configured)
                                →
                         Slack notification sent
                                →
                         Email notification to owner
                                →
                    Feedback marked as "Needs Attention"
```

---

## 8. Requerimientos No Funcionales

### 8.1 Usabilidad
- Time-to-first-widget < 5 minutos
- Dashboard carga < 2 segundos
- No se requiere conocimiento técnico
- Tutorial interactivo incluido
- Help center accesible

### 8.2 Confiabilidad
- 99.9% uptime SLA
- Backup diario de datos
- Recuperación de desastres < 1 hora
- Data retention garantizada

### 8.3 Performance
- Widget load time < 1 segundo
- API response time < 200ms (p95)
- Dashboard analytics query < 3 segundos
- Export generation < 10 segundos (1000 records)

### 8.4 Seguridad
- HTTPS obligatorio
- GDPR compliant por diseño
- No cookies en widget
- No tracking de usuarios
- Data encriptado en reposo y tránsito

### 8.5 Compatibility
- Navegadores: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- Móviles: iOS 14+, Android 10+
- SPAs: React, Vue, Angular, Svelte (auto-detección)

---

## 9. Estrategia de Testing Funcional

### 9.1 Casos de Prueba

**CP-001: Registro Exitoso**
```
Given: Usuario en página de registro
When: Ingresa email válido y password fuerte
And: Acepta términos
And: Submit formulario
Then: Cuenta creada
And: Email de verificación enviado
And: Redirigido a dashboard
```

**CP-002: Instalación de Widget**
```
Given: Usuario autenticado
And: Usuario en sección de widgets
When: Copia código de instalación
And: Pega código en su sitio web
And: Espera 2 minutos
Then: Widget aparece en su sitio
And: Sistema detecta instalación
And: Dashboard muestra estado "Activo"
```

**CP-003: Recolección de Feedback**
```
Given: Widget instalado y activo
When: Visitante da feedback (rating + comentario)
Then: Feedback recibido en sistema
And: Dashboard actualiza contadores
And: Notificación enviada (si configurado)
```

### 9.2 Escenarios de Testing

**Escenario 1: Usuario Nuevo Completo**
1. Registro en sistema
2. Verificación de email
3. Creación de primer widget
4. Instalación en sitio web
5. Recibir primer feedback
6. Ver analytics
7. Exportar datos

**Escenario 2: Usuario Agency**
1. Registro con plan Agency
2. Crear 5 widgets diferentes
3. Configurar webhooks para cada uno
4. Ver analytics consolidados
5. Exportar reporte multi-widget

**Escenario 3: Upgrade de Plan**
1. Usuario en plan Free excede límite
2. Recibe notificación de límite
3. Click en "Upgrade"
4. Selecciona plan Starter
5. Completa pago
6. Límite aumentado inmediatamente

---

## 10. Métricas de Éxito del Producto

### 10.1 Métricas de Adopción

**Activación**: Usuario que recibe primer feedback en 24 horas
**Retorno**: Usuario que vuelve al dashboard en 7 días
**Expansión**: Usuario que upgrade a plan pago o añade widgets

### 10.2 Métricas de Engagement

**Frequency**: Dashboard visits per week
**Depth**: Features utilizadas por usuario
**Duration**: Tiempo en dashboard por sesión

### 10.3 Métricas de Calidad

**CSAT**: Customer Satisfaction de usuarios
**NPS**: Net Promoter Score
**Support Tickets**: Tickets por 1000 usuarios

---

## 11. Roadmap de Funcionalidades

### 11.1 MVP (Q2 2026)
- ✅ Feedback collection (4 emojis)
- ✅ Basic analytics
- ✅ Dashboard overview
- ✅ Journey tracking
- ✅ Single widget

### 11.2 Growth Features (Q3 2026)
- ⏳ Multi-widget support
- ⏳ Advanced analytics
- ⏳ Email notifications
- ⏳ Webhooks (Slack, Discord)
- ⏳ Data export

### 11.3 Advanced Features (Q4 2026)
- ⏳ AI-powered insights
- ⏳ Custom dashboards
- ⏳ API access (Growth plan)
- ⏳ Team collaboration
- ⏳ White-label (Agency plan)

### 11.4 Enterprise Features (Q1 2027)
- ⏳ SSO integration
- ⏳ Advanced security (2FA)
- ⏳ Custom contracts
- ⏳ Dedicated support
- ⏳ SLA guarantees

---

## 12. Anexos

### Anexo A: Glosario

- **Widget**: Componente UI incrustado en sitio web para recolectar feedback
- **Journey**: Secuencia de páginas que un usuario visitó antes de dar feedback
- **Session ID**: Identificador único de visita de usuario
- **Rating**: Valoración de 1-4 dado por usuario (emojis)
- **Analytics**: Análisis y visualización de datos de feedback
- **Webhook**: Notificación HTTP en tiempo real a sistema externo

### Anexo B: Error Codes

| Code | Description | User Message |
|------|-------------|--------------|
| AUTH_001 | Invalid credentials | Email o password incorrectos |
| AUTH_002 | Account locked | Cuenta bloqueada temporalmente |
| AUTH_003 | Email already exists | Email ya registrado |
| WIDGET_001 | Invalid widget ID | Widget no encontrado |
| WIDGET_002 | Widget inactive | Widget desactivado |
| USAGE_001 | Limit exceeded | Límite de uso excedido |
| USAGE_002 | Widget limit reached | Límite de widgets alcanzado |

### Anexo C: Plantillas de Email

**Email de Bienvenida**:
```
Subject: Welcome to Feedback Widget! 🎉

Hi [Name],

Welcome to Feedback Widget! Your account is ready to use.

Your widget ID is: [WIDGET_ID]

Next steps:
1. Copy the installation code
2. Paste it into your website
3. Start collecting feedback!

Need help? Check out our guide: [LINK]

Cheers,
The Feedback Widget Team
```

---

**Documento Version**: 1.0
**Last Updated**: 2026-03-18
**Next Review**: 2026-06-18
**Maintained By**: Feedback Widget Product Team
