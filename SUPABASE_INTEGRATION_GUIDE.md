# Supabase Integration Guide - ELEVATE Multi-Org Backend

## 🎯 Overview
This guide integrates the Flutter app with Supabase backend for multi-organization support (Company A, B, C) with live data sync.

---

## 📋 Setup Steps (Total: ~45 minutes)

### **STEP 1: Create Supabase Project (5 min)**

1. Go to https://supabase.com
2. Click "Sign Up" (use Google/email)
3. Create new project:
   - **Project Name:** `elevate-demo`
   - **Region:** Closest to you
   - **Password:** Save securely
4. Wait 2 minutes for project to initialize
5. Go to **Settings > API**
6. Copy and save:
   ```
   PROJECT_URL = https://xxxxx.supabase.co
   ANON_KEY = eyJ...
   ```

---

### **STEP 2: Create Database Tables (10 min)**

Go to **SQL Editor** in Supabase dashboard. Copy & paste each:

#### **Table 1: organisations**
```sql
create table organisations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  tagline text,
  accent_color text,
  created_at timestamp default now()
);
```

#### **Table 2: employees**
```sql
create table employees (
  id uuid primary key default gen_random_uuid(),
  organisation_id uuid not null references organisations(id),
  name text not null,
  department text,
  region text,
  created_at timestamp default now()
);
```

#### **Table 3: feedbacks**
```sql
create table feedbacks (
  id uuid primary key default gen_random_uuid(),
  organisation_id uuid not null references organisations(id),
  employee_name text,
  feedback_type text,
  comment text,
  created_at timestamp default now()
);
```

#### **Table 4: goals**
```sql
create table goals (
  id uuid primary key default gen_random_uuid(),
  organisation_id uuid not null references organisations(id),
  name text not null,
  progress float default 0,
  created_at timestamp default now()
);
```

#### **Table 5: reviews**
```sql
create table reviews (
  id uuid primary key default gen_random_uuid(),
  organisation_id uuid not null references organisations(id),
  employee_name text,
  cycle text,
  rating text,
  created_at timestamp default now()
);
```

#### **Table 6: heatmap_cells**
```sql
create table heatmap_cells (
  id uuid primary key default gen_random_uuid(),
  organisation_id uuid not null references organisations(id),
  department text,
  region text,
  score float,
  created_at timestamp default now()
);
```

---

### **STEP 3: Seed Test Data (15 min)**

#### **3a: Add 3 Organizations**
```sql
insert into organisations (name, tagline, accent_color) values
  ('Company A - Tech Solutions', 'Innovation through technology', '#0066CC'),
  ('Company B - Retail Commerce', 'Customer-centric retail', '#00A651'),
  ('Company C - Financial Services', 'Trusted financial solutions', '#1f3a5f');
```

#### **3b: Get Organization IDs**
```sql
select id, name from organisations;
```
**Copy the 3 UUIDs** from results (ORG_A_ID, ORG_B_ID, ORG_C_ID)

#### **3c: Add Sample Data for Each Organization**
Replace `{ORG_A_ID}`, `{ORG_B_ID}`, `{ORG_C_ID}` with actual UUIDs.

[Reference: Use data from PRATHAM_SUPABASE_CHECKLIST.md for employee names, feedbacks, goals, reviews, and heatmap data]

---

### **STEP 4: Enable Realtime (3 min)**

1. Go to **Supabase Dashboard > Realtime** (left sidebar)
2. Find `heatmap_cells` table
3. Toggle **ON**

---

### **STEP 5: Update Flutter App (5 min)**

1. Open `lib/supabase_config.dart`
2. Replace:
   ```dart
   static const String supabaseUrl = 'YOUR_PROJECT_URL';
   static const String supabaseAnonKey = 'YOUR_ANON_KEY';
   ```
3. With your actual credentials from Step 1

---

### **STEP 6: Initialize Supabase in App (5 min)**

Update `lib/main.dart`:

```dart
import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();  // ← Add this
  runApp(const ElevateApp());
}
```

---

## 🔄 Using Supabase in Screens

### **Example: Fetch Organisations in Company Picker**

```dart
import 'supabase_config.dart';

// Fetch organisations
final orgs = await SupabaseConfig.getOrganisations();

// Fetch org details
final org = await SupabaseConfig.getOrganisation(orgId);

// Fetch employees for org
final employees = await SupabaseConfig.getEmployees(orgId);

// Add feedback
await SupabaseConfig.addFeedback(orgId, {
  'employee_name': 'Alice Johnson',
  'feedback_type': 'Positive',
  'comment': 'Great work!',
});
```

---

## ✅ Verification Checklist

- [ ] Supabase project created
- [ ] 6 tables created with correct schema
- [ ] 3 organizations seeded
- [ ] Sample data populated
- [ ] Realtime enabled for heatmap_cells
- [ ] `supabase_config.dart` has correct credentials
- [ ] `main()` initializes SupabaseConfig
- [ ] App fetches data from Supabase (not hardcoded)
- [ ] Can add feedback/goals/reviews → stored in Supabase

---

## 🚀 Next: Merge Pratham's Company Picker

Once Supabase is set up:
1. Merge Pratham's `CompanyProfile` code with company picker screen
2. Replace hardcoded data with `SupabaseConfig.getOrganisations()`
3. Connect all 6 screens to use selected organization
4. Test multi-org switching

---

## 📞 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Column not found" error | Check table name spelling in SQL |
| Empty results | Verify data was inserted (check Table Editor) |
| Connection timeout | Check Supabase URL and ANON_KEY are correct |
| Realtime not working | Verify toggle is ON in Supabase dashboard |

---

## 🎯 Result

✅ Backend: Supabase with 3 organizations + real data
✅ Frontend: Flutter app connected to Supabase
✅ Multi-org: Switch between Company A/B/C with live data
✅ ELEVATE Branding: Professional company picker
✅ MediFlow Demo: Ready for hospital customer (Company C)

---

**Estimated completion: ~45 minutes**
**Ready for production after testing!** 🚀
