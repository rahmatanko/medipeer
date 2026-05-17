SET search_path TO medipeer;

-- ･ ｡ﾟ☆: *.☽ .* STUDENTS ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO student
(student_name, student_email, student_department, graduation_year, reputation_score)
VALUES
('Rahma Tanko', 'rahma.tanko@std.medipol.edu.tr', 'Computer Engineering', 2026, 4.80),
('Enesh Bayramova', 'enesh.bayramova@std.medipol.edu.tr', 'Computer Engineering', 2026, 4.70),
('Gana Hosameldin', 'gana.hosameldin@std.medipol.edu.tr', 'Computer Engineering', 2026, 4.60),
('Rayan Radwan', 'rayan.radwan@std.medipol.edu.tr', 'Computer Engineering', 2026, 4.75),
('Tara Demir', 'Tara.demir@std.medipol.edu.tr', 'Computer Engineering', 2027, 4.20),
('Omar Yilmaz', 'omar.yilmaz@std.medipol.edu.tr', 'Software Engineering', 2026, 4.10),
('Mina Kaya', 'mina.kaya@std.medipol.edu.tr', 'Information Systems', 2027, 3.90),
('Ali Cakır', 'ali.cakir@std.medipol.edu.tr', 'Computer Engineering', 2025, 4.30);


-- ･ ｡ﾟ☆: *.☽ .* COURSES ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO course
(course_code, course_name, course_department, semester, instructor)
VALUES
('CSE305', 'Database Systems', 'Computer Engineering', 'Spring 2026', 'Dr. Ahmet Yildiz'),
('CSE221', 'Data Structures', 'Computer Engineering', 'Spring 2026', 'Dr. Elif Kaya'),
('CSE331', 'Operating Systems', 'Computer Engineering', 'Spring 2026', 'Dr. Murat Aydin'),
('CSE204', 'Object Oriented Programming', 'Computer Engineering', 'Fall 2025', 'Dr. Selin Arslan'),
('MATH201', 'Differential Equations', 'Engineering Faculty', 'Spring 2026', 'Dr. Mehmet Demir');


-- ･ ｡ﾟ☆: *.☽ .* ENROLLMENTS ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO enrolls_in
(student_id, course_id, enrollment_year)
VALUES
(1, 1, 2026),
(1, 2, 2026),
(1, 3, 2026),
(2, 1, 2026),
(2, 4, 2026),
(3, 1, 2026),
(3, 5, 2026),
(4, 1, 2026),
(4, 3, 2026),
(5, 2, 2026),
(6, 3, 2026),
(7, 5, 2026),
(8, 1, 2026);


-- ･ ｡ﾟ☆: *.☽ .* NOTES ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO note
(course_id, author_id, note_title, note_description, note_price, file_path)
VALUES
(1, 1, 'Database Normalization Summary', 'Clear explanation of 1NF, 2NF, 3NF, and BCNF with examples.', 75.00, '/uploads/notes/db_normalization.pdf'),
(1, 2, 'ERD and Relational Mapping Guide', 'Step-by-step guide for converting EERD diagrams into relational tables.', 90.00, '/uploads/notes/erd_mapping.pdf'),
(2, 5, 'Data Structures Midterm Review', 'Stacks, queues, trees, graphs, and complexity review.', 60.00, '/uploads/notes/ds_midterm.pdf'),
(3, 4, 'Operating Systems Final Pack', 'Processes, threads, memory management, and file systems summary.', 85.00, '/uploads/notes/os_final.pdf'),
(5, 3, 'Differential Equations Formula Sheet', 'Compact formula sheet for first-order and second-order equations.', 40.00, '/uploads/notes/diff_eq_formulas.pdf');


-- ･ ｡ﾟ☆: *.☽ .* NOTE TAGS ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO note_tag
(note_id, tag_name)
VALUES
(1, 'normalization'),
(1, 'database'),
(1, '3nf'),
(2, 'erd'),
(2, 'relational-model'),
(2, 'database'),
(3, 'data-structures'),
(3, 'midterm'),
(4, 'operating-systems'),
(4, 'final'),
(5, 'math'),
(5, 'formulas');


-- ･ ｡ﾟ☆: *.☽ .* CONTENT PROTECTION LOGS ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO content_protection_log
(note_id, watermark_status, plagiarism_result, content_fingerprint_data)
VALUES
(1, 'Applied', 'Clear', 'fp_db_norm_001'),
(2, 'Applied', 'Clear', 'fp_erd_map_002'),
(3, 'Applied', 'Clear', 'fp_ds_mid_003'),
(4, 'Applied', 'Flagged', 'fp_os_final_004'),
(5, 'Applied', 'Clear', 'fp_math_diff_005');


-- ･ ｡ﾟ☆: *.☽ .* STUDY GROUPS ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO study_group
(course_id, creator_id, group_name, description, max_members)
VALUES
(1, 1, 'Database Systems Study Circle', 'Weekly practice group for SQL, ERD, and normalization.', 8),
(2, 5, 'Data Structures Exam Prep', 'Focused study group for midterm problem solving.', 6),
(3, 4, 'Operating Systems Review Group', 'Discussion group for OS final preparation.', 10),
(5, 3, 'Differential Equations Practice', 'Solving weekly differential equations problems together.', 7);


-- ･ ｡ﾟ☆: *.☽ .* JOINS ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO joins
(student_id, group_id, role)
VALUES
(1, 1, 'Creator'),
(2, 1, 'Moderator'),
(3, 1, 'Member'),
(4, 1, 'Member'),
(5, 2, 'Creator'),
(1, 2, 'Member'),
(4, 3, 'Creator'),
(6, 3, 'Member'),
(3, 4, 'Creator'),
(7, 4, 'Member');


-- ･ ｡ﾟ☆: *.☽ .* GIGS ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO gig
(course_id, student_id, gig_name, gig_description, gig_price, gig_status, service_type)
VALUES
(1, 1, 'SQL Query Tutoring', 'One-hour tutoring session for joins, subqueries, and aggregation.', 150.00, 'Open', 'Tutoring'),
(1, 2, 'ERD Project Review', 'Review and feedback for ERD and relational schema design.', 120.00, 'Open', 'Project Help'),
(2, 5, 'Data Structures Exam Coaching', 'Practice session for trees, graphs, and algorithm complexity.', 100.00, 'In Progress', 'Exam Prep'),
(3, 4, 'Operating Systems Concept Help', 'Explaining process scheduling and memory management.', 130.00, 'Open', 'Tutoring'),
(5, 3, 'Math Assignment Proofreading', 'Checking solution steps and formatting for math assignments.', 80.00, 'Completed', 'Proofreading');


-- ･ ｡ﾟ☆: *.☽ .* TRANSACTIONS ･ ｡ﾟ☆: *.☽ .* --
-- Each transaction is either for a note or a gig
INSERT INTO transaction
(buyer_id, note_id, gig_id, amount, payment_status, payment_method)
VALUES
(5, 1, NULL, 75.00, 'Completed', 'Stripe'),
(6, 2, NULL, 90.00, 'Completed', 'Card'),
(1, 3, NULL, 60.00, 'Completed', 'Stripe'),
(7, NULL, 5, 80.00, 'Completed', 'Cash'),
(3, NULL, 1, 150.00, 'Pending', 'Stripe');


-- ･ ｡ﾟ☆: *.☽ .* RATINGS ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO rating
(giver_id, score, comment)
VALUES
(5, 5, 'Very clear and organized notes.'),
(6, 5, 'Helpful ERD explanations.'),
(1, 4, 'Good review material for the midterm.'),
(7, 5, 'Proofreading was detailed and useful.'),
(3, 4, 'Great SQL tutoring session.');


-- ･ ｡ﾟ☆: *.☽ .* RATING SUBTYPES ･ ｡ﾟ☆: *.☽ .* --
INSERT INTO note_rating
(rating_id, note_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO gig_rating
(rating_id, gig_id)
VALUES
(4, 5),
(5, 1);

INSERT INTO student_rating
(rating_id, student_id)
VALUES
(1, 1),
(2, 2),
(4, 3),
(5, 1);