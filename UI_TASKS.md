# UI Tasks — Atharv

**Goal:** Make all cards clickable and build detail screens. Pratham will set up Supabase in parallel; you wire UI to pull data from there.

## Overview

Current state:
- ✅ Company picker works (3 companies switchable)
- ✅ All 6 screens exist with static data
- ❌ Cards are NOT clickable
- ❌ No detail screens
- ❌ No feedback capture form
- ❌ Data still hardcoded in app (will swap to Supabase)

Your job: **Make cards clickable → drill into details → capture feedback**.

---

## Task 1: Team Detail Screen (1 day)

**Current:** Team tab shows list of employees as cards.  
**New:** Tap employee card → detail screen with:
- Employee name, dept, region
- Recent feedback (for this employee)
- Action button: "Add Feedback"

**File:** Create `lib/screens/team_detail_screen.dart`

```dart
class TeamDetailScreen extends StatelessWidget {
  final String employeeId;  // UUID from Supabase
  final CompanyProfile company;
  
  const TeamDetailScreen({
    required this.employeeId,
    required this.company,
  });
  
  @override
  Widget build(BuildContext context) {
    // TODO: Query Supabase for employee + feedback
    // GET: employees WHERE id = employeeId
    // GET: feedbacks WHERE employee_name = employee.name
    
    return Scaffold(
      appBar: AppBar(title: Text(employee.name)),
      body: Column(
        children: [
          // Employee card (name, dept, region)
          // Feedback list
          // "Add Feedback" button
        ],
      ),
    );
  }
}
```

**Wire in main.dart:** Update `TeamScreen` to make employee cards tappable:

```dart
GestureDetector(
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TeamDetailScreen(
        employeeId: emp.id,  // Will be UUID from Supabase
        company: company,
      ),
    ),
  ),
  child: Card(...),
)
```

---

## Task 2: Feedback Detail & Add Form (1 day)

**Current:** Feedback tab shows list of feedback items.  
**New:** 
- Tap feedback card → detail screen with full text
- Bottom sheet form: "Add Feedback" 
  - Employee dropdown
  - Feedback type (Positive / Constructive)
  - Comment text field
  - Submit button → writes to Supabase

**File:** Create `lib/screens/feedback_form_screen.dart` and `lib/screens/feedback_detail_screen.dart`

```dart
class FeedbackFormScreen extends StatefulWidget {
  final CompanyProfile company;
  
  const FeedbackFormScreen({required this.company});
  
  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  late TextEditingController _commentController;
  String? _selectedEmployee;
  String? _feedbackType;
  
  void _submitFeedback() {
    // TODO: Call Supabase insert
    // INSERT INTO feedbacks (organisation_id, employee_name, feedback_type, comment)
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback saved!')),
    );
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Feedback')),
      body: Column(
        children: [
          // Employee dropdown (query all employees for company)
          DropdownButton(
            hint: Text('Select employee'),
            value: _selectedEmployee,
            onChanged: (value) => setState(() => _selectedEmployee = value),
            items: [], // TODO: Load from Supabase
          ),
          
          // Feedback type (Positive / Constructive)
          SegmentedButton(
            segments: [
              ButtonSegment(label: Text('Positive'), value: 'Positive'),
              ButtonSegment(label: Text('Constructive'), value: 'Constructive'),
            ],
            selected: {_feedbackType ?? ''},
            onSelectionChanged: (value) => setState(() => _feedbackType = value.first),
          ),
          
          // Comment
          TextField(
            controller: _commentController,
            maxLines: 5,
            decoration: InputDecoration(hintText: 'Enter feedback...'),
          ),
          
          // Submit
          ElevatedButton(
            onPressed: _submitFeedback,
            child: Text('Save Feedback'),
          ),
        ],
      ),
    );
  }
}
```

---

## Task 3: Goals Detail Screen (0.5 day)

**Current:** Goals tab shows progress bars.  
**New:** Tap goal card → detail screen with:
- Goal name + progress bar
- Target date (if available)
- Edit progress? (optional for v1)

---

## Task 4: Reviews Detail Screen (0.5 day)

**Current:** Reviews tab shows employee + rating.  
**New:** Tap review → detail screen with full review metadata (cycle, type, notes).

---

## Task 5: Heatmap Interactivity (0.5 day)

**Current:** Heatmap shows static grid.  
**New:** Tap cell → popup showing:
- Department + Region
- Score + trend
- Recent feedback that impacts this cell

---

## Supabase Query Helpers

Pratham will provide these in `lib/services/supabase_service.dart`. Use them like this:

```dart
// Get all employees for a company
final employees = await SupabaseService.getEmployees(organisationId);

// Get feedback for an employee
final feedback = await SupabaseService.getFeedbackByEmployee(
  organisationId: organisationId,
  employeeName: 'Alice Johnson',
);

// Add feedback
await SupabaseService.addFeedback(
  organisationId: organisationId,
  employeeName: 'Alice Johnson',
  feedbackType: 'Positive',
  comment: 'Great work!',
);

// Subscribe to heatmap updates (realtime)
SupabaseService.subscribeToHeatmap(organisationId).listen((update) {
  setState(() {
    // Update UI with new heatmap data
  });
});
```

---

## Checklist

- [ ] Team detail screen + employee tap
- [ ] Feedback form (create + submit to Supabase)
- [ ] Feedback detail screen
- [ ] Goals detail screen
- [ ] Reviews detail screen
- [ ] Heatmap cell tap → detail popup
- [ ] Polish: navigation animations, loading states, error handling
- [ ] Test on emulator with Supabase data

---

## Notes

- **Don't hardcode data** — all queries go through Supabase service
- **Handle loading + error states** — show spinner while fetching
- **Realtime updates** — heatmap should auto-update when new feedback is added (Pratham will wire this)
- **Back button** — all detail screens should pop cleanly

---

## Questions?

Slack me when Pratham gives you the Supabase credentials + service methods.
