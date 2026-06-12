-- One-off cleanup: round all review ratings to nearest half-star.
-- The `feedbacks` table has no rating column so it doesn't need this.
-- Run from the Supabase SQL editor.

-- Preview the change first:
SELECT id, employee_name, cycle, rating AS old_rating,
       ROUND(rating * 2) / 2.0 AS new_rating
FROM reviews
WHERE rating IS NOT NULL
  AND rating <> ROUND(rating * 2) / 2.0
ORDER BY employee_name;

-- Apply (uncomment when ready):
-- UPDATE reviews
-- SET rating = ROUND(rating * 2) / 2.0
-- WHERE rating IS NOT NULL;
