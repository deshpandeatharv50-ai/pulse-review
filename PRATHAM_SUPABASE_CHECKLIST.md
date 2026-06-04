# Pratham — Supabase Setup Checklist

**Goal:** Get Supabase running with 3 companies' test data in 30 minutes.

---

## ✅ Step 1: Create Supabase Project (5 min)

- [ ] Go to https://supabase.com
- [ ] Click "Sign Up" (use Google/email)
- [ ] Create new project
  - Name: `elevate-demo`
  - Region: pick closest to you
  - Password: save it somewhere safe
- [ ] Wait 2 minutes for project to be ready
- [ ] Go to **Settings > API**
- [ ] Copy and save these two things:
  ```
  PROJECT_URL = https://xxxxx.supabase.co
  ANON_KEY = eyJ...
  ```

---

## ✅ Step 2: Create Database Tables (10 min)

Go to **SQL Editor** in Supabase dashboard. Copy & paste each SQL block below, run it.

### Table 1: organisations

```sql
create table organisations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  tagline text,
  accent_color text,
  created_at timestamp default now()
);
```

### Table 2: employees

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

### Table 3: feedbacks

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

### Table 4: goals

```sql
create table goals (
  id uuid primary key default gen_random_uuid(),
  organisation_id uuid not null references organisations(id),
  name text not null,
  progress float default 0,
  created_at timestamp default now()
);
```

### Table 5: reviews

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

### Table 6: heatmap_cells

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

## ✅ Step 3: Seed Test Data (10 min)

### 3a: Add the 3 Companies

Run this SQL:

```sql
insert into organisations (name, tagline, accent_color) values
  ('Company A', 'Tech Solutions', '#0066CC'),
  ('Company B', 'Retail & Commerce', '#00A651'),
  ('Company C', 'Financial Services', '#1f3a5f');
```

### 3b: Get the Company IDs

Run this to see the UUIDs:

```sql
select id, name from organisations;
```

You'll see 3 rows with IDs like `a1b2c3d4-e5f6...`. **Copy all 3 IDs**.

### 3c: Add Company A Data

Replace `{ORG_A_ID}` with the actual ID from step 3b:

```sql
-- Company A Employees
insert into employees (organisation_id, name, department, region) values
  ('{ORG_A_ID}'::uuid, 'Alice Johnson', 'Engineering', 'North America'),
  ('{ORG_A_ID}'::uuid, 'Bob Smith', 'Sales', 'EMEA'),
  ('{ORG_A_ID}'::uuid, 'Carol Davis', 'Marketing', 'APAC'),
  ('{ORG_A_ID}'::uuid, 'David Wilson', 'Engineering', 'North America'),
  ('{ORG_A_ID}'::uuid, 'Emma Brown', 'HR', 'Global'),
  ('{ORG_A_ID}'::uuid, 'Frank Miller', 'Finance', 'North America'),
  ('{ORG_A_ID}'::uuid, 'Grace Lee', 'Product', 'APAC'),
  ('{ORG_A_ID}'::uuid, 'Henry Taylor', 'Customer Success', 'EMEA'),
  ('{ORG_A_ID}'::uuid, 'Ivy Chen', 'Engineering', 'APAC'),
  ('{ORG_A_ID}'::uuid, 'Jack Robinson', 'Sales', 'North America');

-- Company A Feedbacks
insert into feedbacks (organisation_id, employee_name, feedback_type, comment) values
  ('{ORG_A_ID}'::uuid, 'Alice Johnson', 'Positive', 'Excellent code quality'),
  ('{ORG_A_ID}'::uuid, 'Bob Smith', 'Constructive', 'Improve follow-up'),
  ('{ORG_A_ID}'::uuid, 'Carol Davis', 'Positive', 'Great campaign ideas'),
  ('{ORG_A_ID}'::uuid, 'David Wilson', 'Positive', 'Strong technical skills'),
  ('{ORG_A_ID}'::uuid, 'Emma Brown', 'Constructive', 'More proactive support');

-- Company A Goals
insert into goals (organisation_id, name, progress) values
  ('{ORG_A_ID}'::uuid, 'Launch feature', 0.9),
  ('{ORG_A_ID}'::uuid, 'Team engagement', 0.7),
  ('{ORG_A_ID}'::uuid, 'Code quality', 0.85),
  ('{ORG_A_ID}'::uuid, 'Reduce bugs', 0.8);

-- Company A Reviews
insert into reviews (organisation_id, employee_name, cycle, rating) values
  ('{ORG_A_ID}'::uuid, 'Alice Johnson', 'Annual', '4.7'),
  ('{ORG_A_ID}'::uuid, 'Bob Smith', 'Quarterly', '4.2'),
  ('{ORG_A_ID}'::uuid, 'Carol Davis', 'Annual', '4.5'),
  ('{ORG_A_ID}'::uuid, 'David Wilson', 'Quarterly', '4.6');

-- Company A Heatmap
insert into heatmap_cells (organisation_id, department, region, score) values
  ('{ORG_A_ID}'::uuid, 'Engineering', 'North America', 4.5),
  ('{ORG_A_ID}'::uuid, 'Engineering', 'EMEA', 4.2),
  ('{ORG_A_ID}'::uuid, 'Engineering', 'APAC', 3.8),
  ('{ORG_A_ID}'::uuid, 'Sales', 'North America', 4.7),
  ('{ORG_A_ID}'::uuid, 'Sales', 'EMEA', 4.1),
  ('{ORG_A_ID}'::uuid, 'Sales', 'APAC', 3.5),
  ('{ORG_A_ID}'::uuid, 'Marketing', 'North America', 3.9),
  ('{ORG_A_ID}'::uuid, 'Marketing', 'EMEA', 3.6),
  ('{ORG_A_ID}'::uuid, 'Marketing', 'APAC', 2.0),
  ('{ORG_A_ID}'::uuid, 'HR', 'North America', 2.8),
  ('{ORG_A_ID}'::uuid, 'HR', 'EMEA', 3.2),
  ('{ORG_A_ID}'::uuid, 'HR', 'APAC', 3.1);
```

### 3d: Repeat for Company B & C

**For Company B**, replace `{ORG_B_ID}` and use data:
- Employees: Sarah Mitchell, Tom Nakamura, Uma Patel, Victor Lee, Wendy Zhang, Xavier Lopez, Yuki Tanaka, Zoe Anderson, Adam Green, Beth White
- Departments: Operations, Sales, Marketing, Finance
- Regions: North America, EMEA, LATAM
- Similar feedback/goals/reviews structure

**For Company C**, replace `{ORG_C_ID}` and use data:
- Employees: Charles Brown, Diana Prince, Eric Stone, Fiona Scott, George Martin, Helen Price, Iris Lane, James Bond, Karen Bell, Leo Fox
- Departments: Risk, Compliance, Trading, Operations
- Regions: North America, EMEA, APAC
- Similar structure

---

## ✅ Step 4: Enable Realtime (3 min)

- [ ] Go to **Supabase Dashboard > Realtime** (left sidebar)
- [ ] Find `heatmap_cells` table
- [ ] Toggle ON

---

## ✅ Step 5: Verify & Share (2 min)

### Verify in Supabase:
- [ ] Go to **Table Editor**
- [ ] See all 6 tables with data
- [ ] See 3 companies loaded

### Share with team:
- [ ] Slack the **PROJECT_URL** (e.g., `https://xxxxx.supabase.co`)
- [ ] Slack the **ANON_KEY** (e.g., `eyJ...`)
- [ ] Send message: "✅ Supabase ready for Atharv + backend"

---

## 🎯 Done!

When complete, Slack:
```
✅ Supabase project created
✅ 6 tables with 3 companies seeded
✅ Realtime enabled

Project URL: https://xxxxx.supabase.co
Anon Key: eyJ...
```

---

## Stuck?

- **SQL error?** Check you replaced `{ORG_A_ID}` with actual UUID from step 3b
- **Can't find table?** Refresh the Table Editor page
- **Missing data?** Run the SQL again (idempotent — safe to re-run)

---

**Estimated time: 30 min. You got this! 🚀**
