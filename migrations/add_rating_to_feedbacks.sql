-- Add half-star rating column to `feedbacks`.
-- Allowed values: NULL, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0
-- The CHECK constraint enforces half-star granularity so the client can't
-- accidentally insert noisy values like 3.27.

ALTER TABLE feedbacks
  ADD COLUMN IF NOT EXISTS rating NUMERIC(2,1);

ALTER TABLE feedbacks
  DROP CONSTRAINT IF EXISTS feedbacks_rating_half_star;

ALTER TABLE feedbacks
  ADD CONSTRAINT feedbacks_rating_half_star
  CHECK (
    rating IS NULL
    OR (rating >= 0.5 AND rating <= 5.0 AND (rating * 2) = FLOOR(rating * 2))
  );

-- Backfill existing rows: anyone without a rating gets a sensible default
-- derived from feedback_type (Positive → 4.0, Constructive → 2.5).
UPDATE feedbacks
SET rating = CASE
  WHEN feedback_type = 'Positive' THEN 4.0
  WHEN feedback_type = 'Constructive' THEN 2.5
  ELSE NULL
END
WHERE rating IS NULL;
