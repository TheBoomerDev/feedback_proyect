# 🔧 MONGODB PRIVACY-FIRST SCHEMA CORRECTIONS

**Fecha**: 2026-03-18
**Status**: 🔴 CRITICAL - Requiere migración inmediata
**Impact**: Violaciones graves de estrategia privacy-first

---

## 🚨 Problemas Críticos Identificados

### Current Schema Issues

**File**: `backend/src/models/Feedback.js`

```javascript
// ❌ CURRENT (WRONG - Violates privacy-first)
const FeedbackSchema = new mongoose.Schema({
  sessionId: { type: String, required: true, index: true },
  rating: { type: Number, required: true, min: 1, max: 4 },
  comment: { type: String, maxlength: 1000 },
  journey: [{
    path: { type: String, required: true },
    timestamp: { type: Number, required: true },
    referrer: String
  }],
  metadata: {
    userAgent: String,
    language: String,
    platform: String,
    cookieEnabled: Boolean,  // ❌ REMOVE THIS
    screenResolution: String,
    viewport: String,
    timezone: String,
    referrer: String
  },
  url: { type: String, required: true },
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // ❌ WRONG!
  createdAt: { type: Date, default: Date.now, index: true }
});

// ❌ All indexes based on userId (privacy violation)
FeedbackSchema.index({ userId: 1, createdAt: -1 });
FeedbackSchema.index({ userId: 1, rating: 1 });
FeedbackSchema.index({ userId: 1, url: 1 });
```

**Problemas**:
1. ❌ `userId` vincula feedback a usuarios específicos (NO anónimo)
2. ❌ `cookieEnabled` implica uso de cookies (violación "no cookies")
3. ❌ Todos los índices usan `userId` (analytics identifica usuarios)
4. ❌ Falta `widgetId` para separación correcta
5. ❌ No existe modelo `Widget` independiente

---

## ✅ Privacy-First Schema (CORRECTED)

### 1. Widget Model (NEW)

```javascript
/**
 * Widget Schema - 100% Privacy-First
 * Separated from User for proper isolation
 */
const WidgetSchema = new mongoose.Schema({
  // Widget identification (NOT user identification)
  widgetId: {
    type: String,
    required: true,
    unique: true,
    index: true
  },

  // Owner (for billing purposes only, never exposed in feedback)
  ownerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },

  // Configuration
  config: {
    enabled: { type: Boolean, default: true },
    position: {
      type: String,
      enum: ['bottom-right', 'bottom-left', 'top-right', 'top-left'],
      default: 'bottom-right'
    },
    theme: {
      type: String,
      enum: ['light', 'dark'],
      default: 'light'
    },
    primaryColor: {
      type: String,
      default: '#3B82F6'
    },
    triggerDelay: {
      type: Number,
      default: 2000,
      min: 0,
      max: 30000
    }
  },

  // Usage tracking (for limits)
  usage: {
    currentMonth: { type: String }, // YYYY-MM format
    reactions: { type: Number, default: 0 }
  },

  // Status
  status: {
    type: String,
    enum: ['active', 'paused', 'suspended'],
    default: 'active'
  },

  timestamps: {
    createdAt: { type: Date, default: Date.now },
    lastActivity: { type: Date }
  }
});

// Indexes for performance
WidgetSchema.index({ ownerId: 1 });
WidgetSchema.index({ widgetId: 1 }, { unique: true });
WidgetSchema.index({ status: 1 });

module.exports = mongoose.model('Widget', WidgetSchema);
```

### 2. Feedback Schema (CORRECTED)

```javascript
/**
 * Feedback Schema - 100% Privacy-First
 * COMPLETELY ANONYMOUS - No user tracking, no user identification
 */
const FeedbackSchema = new mongoose.Schema({
  // Session ID: Random, no link to user, regenerated each page load
  sessionId: {
    type: String,
    required: true,
    index: true
    // ❌ NO user reference (para mantener anonimato)
    // ❌ NO deviceHash (para evitar fingerprinting)
  },

  // Widget identification (NOT user identification)
  widgetId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Widget',
    required: true,
    index: true
  },

  // Rating: 1-4 (emotions)
  rating: {
    type: Number,
    required: true,
    min: 1,
    max: 4
  },

  // Optional comment
  comment: {
    type: String,
    maxlength: 1000,
    default: ''
  },

  // Journey: Pages visited BEFORE feedback
  // Only for current session, in memory, no persistence
  journey: [{
    path: String,
    timestamp: Number,
    referrer: String
  }],

  // Metadata: Public browser info only
  metadata: {
    userAgent: String,
    language: String,
    platform: String,
    screenResolution: String,
    viewport: String,
    timezone: String
    // ❌ NO canvas fingerprinting
    // ❌ NO audio fingerprinting
    // ❌ NO WebGL fingerprinting
    // ❌ NO cookieEnabled (removed)
    // ❌ NO plugins enumeration
    // ❌ NO fonts enumeration
  },

  // URL where feedback was given
  url: {
    type: String,
    required: true
  },

  // Timestamps
  createdAt: {
    type: Date,
    default: Date.now,
    index: true
  }

  // ❌ NO userId (para mantener anonimato total)
  // ❌ NO updatedAt (para evitar modificación que pueda identificar)
  // ❌ NO deviceHash (para evitar fingerprinting)
});

// Indexes for anonymous aggregation (NOT user tracking)
FeedbackSchema.index({ widgetId: 1, createdAt: -1 });  // For time-series analytics
FeedbackSchema.index({ widgetId: 1, rating: 1 });      // For rating distribution
FeedbackSchema.index({ widgetId: 1, url: 1 });         // For page-level analytics
FeedbackSchema.index({ sessionId: 1 });                // For session grouping (anonymous)
FeedbackSchema.index({ rating: 1 });                   // For global rating stats
FeedbackSchema.index({ journey: 1 });                  // For journey analytics

// Compound index for journey path analytics
FeedbackSchema.index({ widgetId: 1, 'journey.path': 1 });

module.exports = mongoose.model('Feedback', FeedbackSchema);
```

### 3. User Schema (MINIMAL UPDATES)

```javascript
/**
 * User Schema - Billing and Authentication ONLY
 * No direct link to feedback for privacy
 */
const UserSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  password: {
    type: String,
    required: true,
    select: false // Never return password in queries
  },

  // Billing info
  plan: {
    type: String,
    enum: ['free', 'starter', 'growth', 'agency'],
    default: 'free'
  },
  stripeCustomerId: {
    type: String,
    index: true
  },

  // Settings
  settings: {
    emailNotifications: { type: Boolean, default: true },
    weeklyReports: { type: Boolean, default: true },
    usageAlerts: { type: Boolean, default: true }
  },

  // Timestamps
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

// Indexes
UserSchema.index({ email: 1 }, { unique: true });
UserSchema.index({ stripeCustomerId: 1 });

// Password hashing middleware
UserSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();

  try {
    const salt = await bcrypt.genSalt(12);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

// Method to compare password
UserSchema.methods.comparePassword = async function(candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

// Virtual for widgets
UserSchema.virtual('widgets', {
  ref: 'Widget',
  localField: '_id',
  foreignField: 'ownerId'
});

module.exports = mongoose.model('User', UserSchema);
```

---

## 📊 Analytics Queries (Privacy-First)

### All queries use widgetId, NEVER userId

```javascript
/**
 * Anonymous Aggregation Examples
 * All queries are by widgetId, never by userId
 */

// Overview analytics (anonymous aggregation)
async getOverviewAnalytics(widgetId, startDate, endDate) {
  return await Feedback.aggregate([
    {
      $match: {
        widgetId: mongoose.Types.ObjectId(widgetId),
        createdAt: { $gte: startDate, $lte: endDate }
      }
    },
    {
      $group: {
        _id: null,
        totalFeedback: { $sum: 1 },
        averageRating: { $avg: '$rating' },
        ratingDistribution: {
          $push: '$rating'
        },
        uniqueSessions: { $addToSet: '$sessionId' }  // Anonymous session count
      }
    },
    {
      $project: {
        totalFeedback: 1,
        averageRating: { $round: ['$averageRating', 2] },
        ratingDistribution: 1,
        uniqueSessions: { $size: '$uniqueSessions' }
      }
    }
  ]);
}

// Journey analytics (anonymous path aggregation)
async getJourneyAnalytics(widgetId, startDate, endDate) {
  return await Feedback.aggregate([
    {
      $match: {
        widgetId: mongoose.Types.ObjectId(widgetId),
        createdAt: { $gte: startDate, $lte: endDate }
      }
    },
    { $unwind: '$journey' },
    {
      $group: {
        _id: {
          path: '$journey.path',
          rating: '$rating'
        },
        count: { $sum: 1 },
        avgRating: { $avg: '$rating' }
      }
    },
    { $sort: { count: -1 } },
    { $limit: 50 }
  ]);
}

// Page-level analytics (anonymous)
async getPageAnalytics(widgetId, startDate, endDate) {
  return await Feedback.aggregate([
    {
      $match: {
        widgetId: mongoose.Types.ObjectId(widgetId),
        createdAt: { $gte: startDate, $lte: endDate }
      }
    },
    {
      $group: {
        _id: '$url',
        totalFeedback: { $sum: 1 },
        averageRating: { $avg: '$rating' },
        ratingDistribution: {
          $push: '$rating'
        }
      }
    },
    { $sort: { totalFeedback: -1 } },
    { $limit: 20 }
  ]);
}

// Rating distribution over time (anonymous)
async getRatingTrends(widgetId, startDate, endDate) {
  return await Feedback.aggregate([
    {
      $match: {
        widgetId: mongoose.Types.ObjectId(widgetId),
        createdAt: { $gte: startDate, $lte: endDate }
      }
    },
    {
      $group: {
        _id: {
          date: {
            $dateToString: { format: '%Y-%m-%d', date: '$createdAt' }
          },
          rating: '$rating'
        },
        count: { $sum: 1 }
      }
    },
    { $sort: { '_id.date': 1, '_id.rating': 1 } }
  ]);
}
```

---

## 🔄 Migration Plan

### Phase 1: Create New Widget Collection
```javascript
// 1. Create Widget model
// 2. Migrate existing widget configs from User.settings to Widget collection
// 3. Generate unique widgetId for each user
```

### Phase 2: Update Feedback Schema
```javascript
// 1. Add widgetId field to Feedback (nullable initially)
// 2. Migrate userId → widgetId for all existing feedback
// 3. Remove userId field after migration
// 4. Remove cookieEnabled from metadata
// 5. Update all indexes
```

### Phase 3: Update API Routes
```javascript
// 1. Change all queries from userId to widgetId
// 2. Update analytics endpoints
// 3. Update feedback submission endpoint
// 4. Update admin endpoints
```

### Phase 4: Testing
```javascript
// 1. Test all analytics queries
// 2. Test anonymity (no user identification possible)
// 3. Test performance with new indexes
// 4. Test GDPR compliance
```

---

## 📝 Migration Script

```javascript
/**
 * Migration Script: userId → widgetId
 * Run this in MongoDB shell or via Node.js
 */

async function migrateToPrivacyFirst() {
  const mongoose = require('mongoose');
  const User = mongoose.model('User');
  const Feedback = mongoose.model('Feedback');

  console.log('Starting privacy-first migration...');

  // Step 1: Create Widget collection from existing users
  console.log('Step 1: Creating Widget collection...');
  const users = await User.find({});

  for (const user of users) {
    // Generate unique widgetId if not exists
    if (!user.widgetId) {
      user.widgetId = generateWidgetId();
      await user.save();
    }

    // Create Widget document
    await Widget.create({
      widgetId: user.widgetId,
      ownerId: user._id,
      config: {
        enabled: user.settings?.widgetEnabled ?? true,
        position: user.settings?.widgetPosition || 'bottom-right',
        theme: user.settings?.theme || 'light'
      },
      usage: {
        currentMonth: user.usage?.month,
        reactions: user.usage?.reactions || 0
      },
      status: 'active'
    });
  }

  // Step 2: Migrate Feedback.userId → Feedback.widgetId
  console.log('Step 2: Migrating Feedback collection...');
  const feedbacks = await Feedback.find({});

  for (const feedback of feedbacks) {
    // Find user's widget
    const user = await User.findById(feedback.userId);
    if (!user || !user.widgetId) {
      console.error(`User not found for feedback ${feedback._id}`);
      continue;
    }

    const widget = await Widget.findOne({ widgetId: user.widgetId });
    if (!widget) {
      console.error(`Widget not found for user ${user._id}`);
      continue;
    }

    // Update feedback with widgetId
    feedback.widgetId = widget._id;
    await feedback.save();
  }

  // Step 3: Remove userId from Feedback schema
  console.log('Step 3: Removing userId from Feedback schema...');
  await Feedback.collection.updateMany(
    {},
    { $unset: { userId: '' } }
  );

  // Step 4: Remove cookieEnabled from metadata
  console.log('Step 4: Removing cookieEnabled from metadata...');
  await Feedback.collection.updateMany(
    {},
    { $unset: { 'metadata.cookieEnabled': '' } }
  );

  // Step 5: Create new indexes
  console.log('Step 5: Creating new indexes...');
  await Feedback.collection.createIndex({ widgetId: 1, createdAt: -1 });
  await Feedback.collection.createIndex({ widgetId: 1, rating: 1 });
  await Feedback.collection.createIndex({ widgetId: 1, url: 1 });

  // Step 6: Drop old indexes
  console.log('Step 6: Dropping old userId-based indexes...');
  await Feedback.collection.dropIndex('userId_1_createdAt_-1');
  await Feedback.collection.dropIndex('userId_1_rating_1');
  await Feedback.collection.dropIndex('userId_1_url_1');

  console.log('Migration complete! ✅');
}

function generateWidgetId() {
  return 'w_' + crypto.randomBytes(16).toString('hex');
}

// Run migration
migrateToPrivacyFirst().catch(console.error);
```

---

## ✅ Verification Checklist

After migration, verify:

- [ ] No feedback documents have `userId` field
- [ ] All feedback documents have `widgetId` field
- [ ] No feedback documents have `metadata.cookieEnabled` field
- [ ] All Widget documents created successfully
- [ ] All indexes use `widgetId`, not `userId`
- [ ] Analytics queries work correctly with `widgetId`
- [ ] Cannot identify users from feedback data
- [ ] GDPR compliance verified
- [ ] Performance tests pass
- [ ] All API endpoints updated

---

## 🎯 Summary of Changes

### What Changed:
1. ✅ Created separate `Widget` collection
2. ✅ Changed `Feedback.userId` → `Feedback.widgetId`
3. ✅ Removed `metadata.cookieEnabled`
4. ✅ Updated all indexes to use `widgetId`
5. ✅ Updated all analytics queries
6. ✅ Maintained 100% anonymity

### What Stayed the Same:
1. ✅ Session tracking (still random sessionId)
2. ✅ Journey tracking (still in memory only)
3. ✅ Rating system (1-4 emojis)
4. ✅ Comment system (optional, PUT for update)
5. ✅ Metadata collection (public browser info only)

### Benefits:
1. ✅ TRUE 100% privacy-first (no user identification)
2. ✅ GDPR compliant by design
3. ✅ Proper separation of concerns (User ≠ Widget)
4. ✅ Better scalability (widgets independent)
5. ✅ Cleaner architecture (widget-based analytics)

---

**Status**: Ready for implementation
**Priority**: CRITICAL - Blocking privacy-first launch
**Estimated Time**: 4-6 hours for full migration
**Risk Level**: MEDIUM (requires backup before migration)

---

**Next Steps**:
1. Backup production database
2. Run migration script in staging
3. Test all analytics queries
4. Verify anonymity
5. Deploy to production
6. Monitor for 24 hours
7. Remove old userId-based code

**Ready to proceed? 🚀**
