SET search_path TO medipeer;

-- ･ ｡ﾟ☆: *.☽ .* Find all notes for a specific course ･ ｡ﾟ☆: *.☽ .* --

SELECT
    note_title,
    note_price,
    author_name,
    author_reputation,
    course_code
FROM view_note_marketplace
WHERE course_code = 'CSE305'
ORDER BY author_reputation DESC;


-- ･ ｡ﾟ☆: *.☽ .* Find notes using a specific tag ･ ｡ﾟ☆: *.☽ .* --

SELECT
    n.note_title,
    n.note_price,
    nt.tag_name
FROM note n
JOIN note_tag nt ON n.note_id = nt.note_id
WHERE nt.tag_name = 'database';


-- ･ ｡ﾟ☆: *.☽ .* List all students enrolled in Database Systems ･ ｡ﾟ☆: *.☽ .* --

SELECT
    s.student_name,
    s.student_email,
    c.course_code,
    c.course_name
FROM student s
JOIN enrolls_in e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id
WHERE c.course_code = 'CSE305';


-- ･ ｡ﾟ☆: *.☽ .* Show all study groups with available seats ･ ｡ﾟ☆: *.☽ .* --

SELECT
    group_name,
    course_code,
    current_members,
    max_members,
    max_members - current_members AS available_seats
FROM view_study_groups
WHERE current_members < max_members;


-- ･ ｡ﾟ☆: *.☽ .* Find open tutoring gigs ･ ｡ﾟ☆: *.☽ .* --

SELECT
    gig_name,
    provider_name,
    gig_price,
    course_code,
    provider_reputation
FROM view_gig_marketplace
WHERE gig_status = 'Open'
AND service_type = 'Tutoring'
ORDER BY provider_reputation DESC;


-- ･ ｡ﾟ☆: *.☽ .* Show total completed transaction amount ･ ｡ﾟ☆: *.☽ .* --

SELECT
    SUM(amount) AS total_completed_revenue
FROM transaction
WHERE payment_status = 'Completed';


-- ･ ｡ﾟ☆: *.☽ .* Show transactions with buyer and purchased item ･ ｡ﾟ☆: *.☽ .* --

SELECT
    buyer_name,
    COALESCE(note_title, gig_name) AS purchased_item,
    amount,
    payment_method,
    payment_status
FROM view_transaction_summary
ORDER BY transaction_date DESC;


-- ･ ｡ﾟ☆: *.☽ .* Show top 5 contributors ･ ｡ﾟ☆: *.☽ .* --

SELECT
    student_name,
    student_department,
    reputation_score
FROM view_top_contributors
LIMIT 5;


-- ･ ｡ﾟ☆: *.☽ .* Count notes per course ･ ｡ﾟ☆: *.☽ .* --

SELECT
    c.course_code,
    c.course_name,
    COUNT(n.note_id) AS total_notes
FROM course c
LEFT JOIN note n ON c.course_id = n.course_id
GROUP BY c.course_id, c.course_code, c.course_name
ORDER BY total_notes DESC;


-- ･ ｡ﾟ☆: *.☽ .* Average rating for each note ･ ｡ﾟ☆: *.☽ .* --

SELECT
    n.note_title,
    ROUND(AVG(r.score)::NUMERIC, 2) AS average_rating,
    COUNT(r.rating_id) AS rating_count
FROM note n
JOIN note_rating nr ON n.note_id = nr.note_id
JOIN rating r ON nr.rating_id = r.rating_id
GROUP BY n.note_id, n.note_title
ORDER BY average_rating DESC;


-- ･ ｡ﾟ☆: *.☽ .* Full-text search for notes ･ ｡ﾟ☆: *.☽ .* --

SELECT
    note_title,
    note_description,
    note_price
FROM note
WHERE to_tsvector('english', note_title || ' ' || COALESCE(note_description, ''))
@@ plainto_tsquery('english', 'database normalization');


-- ･ ｡ﾟ☆: *.☽ .* Find students who are enrolled in the same course ･ ｡ﾟ☆: *.☽ .* --

SELECT
    c.course_code,
    c.course_name,
    s.student_name
FROM course c
JOIN enrolls_in e ON c.course_id = e.course_id
JOIN student s ON e.student_id = s.student_id
WHERE c.course_code = 'CSE305'
ORDER BY s.student_name;


-- ･ ｡ﾟ☆: *.☽ .* Show each student's activity summary ･ ｡ﾟ☆: *.☽ .* --

SELECT
    student_name,
    enrolled_courses,
    uploaded_notes,
    posted_gigs,
    joined_groups,
    reputation_score
FROM view_student_profiles
ORDER BY reputation_score DESC;