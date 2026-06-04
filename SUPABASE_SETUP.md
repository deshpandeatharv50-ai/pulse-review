# Supabase Setup — Pratham

**Goal:** Set up Supabase as the single source of truth for all test data (Company A, B, C). Atharv and you will pull data from here.

## Step 1: Create Supabase Project

1. Go to https://supabase.com and sign up (free tier OK)
2. Create a new project:
   - **Name:** `elevate-demo` (or your choice)
   - **Region:** Closest to you (e.g., `us-east-1`)
   - **Database Password:** Save this securely
3. Wait for project to be ready (~2 min)
4. Go to **Settings > API** and copy:
   - `Project URL` (e.g., `https://xxxxx.supabase.co`)
   - `anon` key (public API key)
5. Slack/email these to the team

## Step 2: Create Tables

Go to Supabase dashboard → **SQL Editor** and run each query below.

### Table: organisations

```sql
create table organisations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  tagline text,
  accent_color text,
  created_at timestamp default now()
);
```

### Table: employees

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

### Table: feedbacks

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

### Table: goals

```sql
create table goals (
  id uuid primary key default gen_random_uuid(),
  organisation_id uuid not null references organisations(id),
  name text not null,
  progress float default 0,
  created_at timestamp default now()
);
```

### Table: reviews

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

### Table: heatmap_cells

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

## Step 3: Seed Test Data

Run this SQL to insert Company A, B, C data:

```sql
-- Insert organisations
insert into organisations (name, tagline, accent_color) values
  ('Company A', 'Tech Solutions', '#0066CC'),
  ('Company B', 'Retail & Commerce', '#00A651'),
  ('Company C', 'Financial Services', '#1f3a5f');

-- Get org IDs (you'll need these for the inserts below)
-- Run this query first, note the UUIDs
select id, name from organisations;
```

Copy the 3 UUIDs returned and use them in the inserts below. Replace `{ORG_A_ID}`, `{ORG_B_ID}`, `{ORG_C_ID}` with actual IDs.

```sql
-- Company A: Employees
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

-- Company A: Feedbacks
insert into feedbacks (organisation_id, employee_name, feedback_type, comment) values
  ('{ORG_A_ID}'::uuid, 'Alice Johnson', 'Positive', 'Excellent code quality'),
  ('{ORG_A_ID}'::uuid, 'Bob Smith', 'Constructive', 'Improve follow-up'),
  ('{ORG_A_ID}'::uuid, 'Carol Davis', 'Positive', 'Great campaign ideas'),
  ('{ORG_A_ID}'::uuid, 'David Wilson', 'Positive', 'Strong technical skills'),
  ('{ORG_A_ID}'::uuid, 'Emma Brown', 'Constructive', 'More proactive support');

-- Company A: Goals
insert into goals (organisation_id, name, progress) values
  ('{ORG_A_ID}'::uuid, 'Launch feature', 0.9),
  ('{ORG_A_ID}'::uuid, 'Team engagement', 0.7),
  ('{ORG_A_ID}'::uuid, 'Code quality', 0.85),
  ('{ORG_A_ID}'::uuid, 'Reduce bugs', 0.8);

-- Company A: Reviews
insert into reviews (organisation_id, employee_name, cycle, rating) values
  ('{ORG_A_ID}'::uuid, 'Alice Johnson', 'Annual', '4.7'),
  ('{ORG_A_ID}'::uuid, 'Bob Smith', 'Quarterly', '4.2'),
  ('{ORG_A_ID}'::uuid, 'Carol Davis', 'Annual', '4.5'),
  ('{ORG_A_ID}'::uuid, 'David Wilson', 'Quarterly', '4.6');

-- Company A: Heatmap
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

-- Repeat for Company B and Company C (use {ORG_B_ID} and {ORG_C_ID})
-- See SUPABASE_SEED_DATA.sql for complete script
```

**Complete seed script:** See `docs/SUPABASE_SEED_DATA.sql` in this repo for all 3 companies.

## Step 4: Enable Realtime

Go to **Supabase Dashboard > Realtime** and enable it for `heatmap_cells` table:
1. Click "Realtime" in left sidebar
2. Toggle ON for `heatmap_cells`
3. This allows live updates when feedback is added

## Step 5: Share Credentials

Create a `.env` file in the project root (DO NOT commit):

```
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

Share URL + key with Atharv and the team via Slack (secure channel).

## Step 6: Verify Data

In Supabase Dashboard:
1. Go to **Table Editor**
2. Check each table has data (organisations, employees, feedbacks, goals, reviews, heatmap_cells)
3. Confirm all 3 companies are loaded with their test data

## Next

Once this is done:
1. Slack the project URL + anon key
2. Atharv will wire UI to query this data
3. Realtime heatmap updates will work automatically

**Estimated time:** 30 min setup + seed

Questions? Slack me.
