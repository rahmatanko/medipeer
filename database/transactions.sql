SET search_path TO medipeer;

-- ･ ｡ﾟ☆: *.☽ .* Safe note purchase using COMMIT ･ ｡ﾟ☆: *.☽ .* --

BEGIN;

INSERT INTO transaction (
    buyer_id,
    note_id,
    gig_id,
    amount,
    payment_status,
    payment_method
)
SELECT
    5,
    note_id,
    NULL,
    note_price,
    'Completed',
    'Stripe'
FROM note
WHERE note_id = 1;

COMMIT;

-- ･ ｡ﾟ☆: *.☽ .* Failed payment using ROLLBACK ･ ｡ﾟ☆: *.☽ .* --

BEGIN;

INSERT INTO transaction (
    buyer_id,
    note_id,
    gig_id,
    amount,
    payment_status,
    payment_method
)
SELECT
    6,
    note_id,
    NULL,
    note_price,
    'Pending',
    'Card'
FROM note
WHERE note_id = 2;

-- Simulating failed payment
ROLLBACK;

-- ･ ｡ﾟ☆: *.☽ .* Gig payment transaction ･ ｡ﾟ☆: *.☽ .* --

BEGIN;

INSERT INTO transaction (
    buyer_id,
    note_id,
    gig_id,
    amount,
    payment_status,
    payment_method
)
SELECT
    7,
    NULL,
    gig_id,
    gig_price,
    'Completed',
    'Stripe'
FROM gig
WHERE gig_id = 1;

UPDATE gig
SET gig_status = 'In Progress'
WHERE gig_id = 1;

COMMIT;

-- ･ ｡ﾟ☆: *.☽ .* Savepoint example for group joining ･ ｡ﾟ☆: *.☽ .* --

BEGIN;

SAVEPOINT before_join;

INSERT INTO joins (
    student_id,
    group_id,
    role
)
VALUES (
    8,
    1,
    'Member'
);

-- If something goes wrong:
-- ROLLBACK TO SAVEPOINT before_join;

COMMIT;

-- ･ ｡ﾟ☆: *.☽ .* Procedure-based note purchase ･ ｡ﾟ☆: *.☽ .* --

BEGIN;

CALL purchase_note(8, 4, 'Stripe');

COMMIT;

-- ･ ｡ﾟ☆: *.☽ .* Procedure-based study group join ･ ｡ﾟ☆: *.☽ .* --

BEGIN;

CALL join_study_group(6, 1);

COMMIT;