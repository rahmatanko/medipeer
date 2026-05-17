SET search_path TO medipeer;

-- ･ ｡ﾟ☆: *.☽ .* Notes with course and author information ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE VIEW view_note_marketplace AS
SELECT
    n.note_id,
    n.note_title,
    n.note_description,
    n.note_price,
    n.upload_date,
    n.file_path,
    c.course_code,
    c.course_name,
    c.course_department,
    c.semester,
    c.instructor,
    s.student_id AS author_id,
    s.student_name AS author_name,
    s.reputation_score AS author_reputation
FROM note n
JOIN course c ON n.course_id = c.course_id
JOIN student s ON n.author_id = s.student_id;


-- ･ ｡ﾟ☆: *.☽ .* Study groups with course and member count ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE VIEW view_study_groups AS
SELECT
    sg.group_id,
    sg.group_name,
    sg.description,
    sg.max_members,
    COUNT(j.student_id) AS current_members,
    c.course_code,
    c.course_name,
    creator.student_name AS creator_name
FROM study_group sg
JOIN course c ON sg.course_id = c.course_id
JOIN student creator ON sg.creator_id = creator.student_id
LEFT JOIN joins j ON sg.group_id = j.group_id
GROUP BY
    sg.group_id,
    sg.group_name,
    sg.description,
    sg.max_members,
    c.course_code,
    c.course_name,
    creator.student_name;


-- ･ ｡ﾟ☆: *.☽ .* Gig marketplace ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE VIEW view_gig_marketplace AS
SELECT
    g.gig_id,
    g.gig_name,
    g.gig_description,
    g.gig_price,
    g.gig_status,
    g.service_type,
    g.creation_date,
    c.course_code,
    c.course_name,
    s.student_id AS provider_id,
    s.student_name AS provider_name,
    s.reputation_score AS provider_reputation
FROM gig g
JOIN course c ON g.course_id = c.course_id
JOIN student s ON g.student_id = s.student_id;


-- ･ ｡ﾟ☆: *.☽ .* Student academic profile ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE VIEW view_student_profiles AS
SELECT
    s.student_id,
    s.student_name,
    s.student_email,
    s.student_department,
    s.graduation_year,
    s.reputation_score,
    COUNT(DISTINCT e.course_id) AS enrolled_courses,
    COUNT(DISTINCT n.note_id) AS uploaded_notes,
    COUNT(DISTINCT g.gig_id) AS posted_gigs,
    COUNT(DISTINCT j.group_id) AS joined_groups
FROM student s
LEFT JOIN enrolls_in e ON s.student_id = e.student_id
LEFT JOIN note n ON s.student_id = n.author_id
LEFT JOIN gig g ON s.student_id = g.student_id
LEFT JOIN joins j ON s.student_id = j.student_id
GROUP BY s.student_id;


-- ･ ｡ﾟ☆: *.☽ .* Transaction summary ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE VIEW view_transaction_summary AS
SELECT
    t.transaction_id,
    buyer.student_name AS buyer_name,
    t.amount,
    t.payment_status,
    t.payment_method,
    t.transaction_date,
    n.note_title,
    g.gig_name
FROM transaction t
JOIN student buyer ON t.buyer_id = buyer.student_id
LEFT JOIN note n ON t.note_id = n.note_id
LEFT JOIN gig g ON t.gig_id = g.gig_id;


-- ･ ｡ﾟ☆: *.☽ .* Top contributors by reputation ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE VIEW view_top_contributors AS
SELECT
    student_id,
    student_name,
    student_department,
    reputation_score
FROM student
ORDER BY reputation_score DESC;