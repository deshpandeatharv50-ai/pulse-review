# ELEVATE — Real-time Performance Management (Mobile)

**Project Status:** MVP Demo (5-day delivery)  
**Current State:** UI complete, data hardcoded → moving to Supabase backend

---

## Quick Start

### For Pratham (Supabase Setup)

👉 **Read:** [`SUPABASE_SETUP.md`](SUPABASE_SETUP.md)

**Your job:** Create Supabase project, seed 3 companies' test data, enable realtime.  
**Time:** 30 min  
**Deliverable:** Supabase URL + anon key → share in Slack

### For Atharv (UI Development)

👉 **Read:** [`UI_TASKS.md`](UI_TASKS.md)

**Your job:** Make cards clickable, build detail screens, wire feedback capture form.  
**Time:** 1 day  
**Wait for:** Pratham's Supabase credentials + I'll provide `SupabaseService` helper methods

---

## Architecture

```
App Screens (6 tabs):
├── Dashboard (KPIs)
├── Team (employees)
├── Feedback (reviews)
├── Goals (OKRs)
├── Reviews (performance)
└── Heatmap (dept × region)

Company Picker (before login):
├── Company A (Tech Solutions)
├── Company B (Retail & Commerce)
└── Company C (Financial Services)

Data Flow:
- UI (Flutter) ← Supabase (hosted backend)
- All companies share same test data in Supabase
- Realtime heatmap updates via Supabase Realtime
```

---

## Current Progress

| Feature | Status | Owner |
|---|---|---|
| ELEVATE branding | ✅ Done | — |
| Company picker (3 orgs) | ✅ Done | — |
| 6 screens (static UI) | ✅ Done | — |
| Clickable cards | ❌ In Progress | Atharv |
| Detail screens | ❌ In Progress | Atharv |
| Feedback form | ❌ In Progress | Atharv |
| Supabase schema | ❌ In Progress | Pratham |
| Realtime heatmap | ❌ Blocked on Supabase | — |
| Polish + QA | ❌ Week 4 | — |

---

## How to Run (Local)

```bash
# Install deps
flutter pub get

# Run on emulator
flutter run

# Build signed APK (demo delivery)
flutter build apk --debug
```

**Test credentials (hardcoded auth for now):**
- Email: `james.bellano@acmecorp.com`
- Password: `demo123`

---

## Git Commits

- **ff6b927** — Initial commit: 6 screens + login
- **5567117** — Fix Gradle/Java 21 compatibility
- **9d702d2** — ELEVATE branding + company picker + 3 data profiles
- **b2d5c5c** — Parallel work instructions (Pratham: Supabase, Atharv: UI)

---

## Timeline

**Day 1 (Now):**
- ✅ ELEVATE branding + company picker done
- ⏳ Pratham: Start Supabase setup
- ⏳ Atharv: Start UI clickable cards

**Day 2:**
- ✅ Detail screens + feedback form (Atharv)
- ✅ Supabase seeded (Pratham)
- 🔧 Wire queries into UI

**Day 3:**
- ✅ All data from Supabase
- ✅ Realtime heatmap working

**Day 4:**
- ✅ Polish + QA

**Day 5:**
- ✅ Final APK + demo script

---

## Questions?

- **Pratham:** See SUPABASE_SETUP.md
- **Atharv:** See UI_TASKS.md
- **Backend:** Will send SupabaseService helpers once Supabase is ready

---

## APK Location

`build/app/outputs/flutter-apk/app-debug.apk`

Install on phone:
```bash
flutter install && flutter run
```
