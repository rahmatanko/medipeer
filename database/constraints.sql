SET search_path TO medipeer;


-- ･ ｡ﾟ☆: *.☽ .* STUDENT constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE student
ADD CONSTRAINT chk_student_email_medipol
CHECK (student_email LIKE '%@std.medipol.edu.tr');

ALTER TABLE student
ADD CONSTRAINT chk_graduation_year
CHECK (graduation_year IS NULL OR graduation_year BETWEEN 2024 AND 2035);

ALTER TABLE student
ADD CONSTRAINT chk_reputation_score
CHECK (reputation_score BETWEEN 0 AND 5);


-- ･ ｡ﾟ☆: *.☽ .* ENROLLS_IN constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE enrolls_in
ADD CONSTRAINT fk_enrolls_student
FOREIGN KEY (student_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

ALTER TABLE enrolls_in
ADD CONSTRAINT fk_enrolls_course
FOREIGN KEY (course_id)
REFERENCES course(course_id)
ON DELETE CASCADE;

ALTER TABLE enrolls_in
ADD CONSTRAINT chk_enrollment_year
CHECK (enrollment_year BETWEEN 2020 AND 2035);


-- ･ ｡ﾟ☆: *.☽ .* NOTE constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE note
ADD CONSTRAINT fk_note_course
FOREIGN KEY (course_id)
REFERENCES course(course_id)
ON DELETE CASCADE;

ALTER TABLE note
ADD CONSTRAINT fk_note_author
FOREIGN KEY (author_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

ALTER TABLE note
ADD CONSTRAINT chk_note_price
CHECK (note_price >= 0);


-- ･ ｡ﾟ☆: *.☽ .* NOTE_TAG constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE note_tag
ADD CONSTRAINT fk_note_tag_note
FOREIGN KEY (note_id)
REFERENCES note(note_id)
ON DELETE CASCADE;


-- ･ ｡ﾟ☆: *.☽ .* CONTENT_PROTECTION_LOG constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE content_protection_log
ADD CONSTRAINT fk_content_log_note
FOREIGN KEY (note_id)
REFERENCES note(note_id)
ON DELETE CASCADE;

ALTER TABLE content_protection_log
ADD CONSTRAINT chk_watermark_status
CHECK (watermark_status IN ('Applied', 'Failed', 'Pending'));

ALTER TABLE content_protection_log
ADD CONSTRAINT chk_plagiarism_result
CHECK (plagiarism_result IN ('Clear', 'Flagged', 'Pending'));


-- ･ ｡ﾟ☆: *.☽ .* STUDY_GROUP constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE study_group
ADD CONSTRAINT fk_group_course
FOREIGN KEY (course_id)
REFERENCES course(course_id)
ON DELETE CASCADE;

ALTER TABLE study_group
ADD CONSTRAINT fk_group_creator
FOREIGN KEY (creator_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

ALTER TABLE study_group
ADD CONSTRAINT chk_max_members
CHECK (max_members > 0);


-- ･ ｡ﾟ☆: *.☽ .* JOINS constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE joins
ADD CONSTRAINT fk_joins_student
FOREIGN KEY (student_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

ALTER TABLE joins
ADD CONSTRAINT fk_joins_group
FOREIGN KEY (group_id)
REFERENCES study_group(group_id)
ON DELETE CASCADE;

ALTER TABLE joins
ADD CONSTRAINT chk_group_role
CHECK (role IN ('Creator', 'Moderator', 'Member'));


-- ･ ｡ﾟ☆: *.☽ .* GIG constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE gig
ADD CONSTRAINT fk_gig_course
FOREIGN KEY (course_id)
REFERENCES course(course_id)
ON DELETE CASCADE;

ALTER TABLE gig
ADD CONSTRAINT fk_gig_student
FOREIGN KEY (student_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

ALTER TABLE gig
ADD CONSTRAINT chk_gig_price
CHECK (gig_price >= 0);

ALTER TABLE gig
ADD CONSTRAINT chk_gig_status
CHECK (gig_status IN ('Open', 'In Progress', 'Completed', 'Cancelled'));

ALTER TABLE gig
ADD CONSTRAINT chk_service_type
CHECK (service_type IN ('Tutoring', 'Proofreading', 'Project Help', 'Exam Prep', 'Other'));


-- ･ ｡ﾟ☆: *.☽ .* TRANSACTION constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_buyer
FOREIGN KEY (buyer_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_note
FOREIGN KEY (note_id)
REFERENCES note(note_id)
ON DELETE SET NULL;

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_gig
FOREIGN KEY (gig_id)
REFERENCES gig(gig_id)
ON DELETE SET NULL;

ALTER TABLE transaction
ADD CONSTRAINT chk_transaction_amount
CHECK (amount >= 0);

ALTER TABLE transaction
ADD CONSTRAINT chk_payment_status
CHECK (payment_status IN ('Pending', 'Completed', 'Failed', 'Refunded'));

ALTER TABLE transaction
ADD CONSTRAINT chk_payment_method
CHECK (payment_method IN ('Card', 'Stripe', 'Cash', 'Bank Transfer'));

ALTER TABLE transaction
ADD CONSTRAINT chk_transaction_target
CHECK (
    (note_id IS NOT NULL AND gig_id IS NULL)
    OR
    (note_id IS NULL AND gig_id IS NOT NULL)
);


-- ･ ｡ﾟ☆: *.☽ .* RATING constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE rating
ADD CONSTRAINT fk_rating_giver
FOREIGN KEY (giver_id)
REFERENCES student(student_id)
ON DELETE CASCADE;

ALTER TABLE rating
ADD CONSTRAINT chk_rating_score
CHECK (score BETWEEN 1 AND 5);


-- ･ ｡ﾟ☆: *.☽ .* Rating subtype constraints ･ ｡ﾟ☆: *.☽ .* --
ALTER TABLE note_rating
ADD CONSTRAINT fk_note_rating_rating
FOREIGN KEY (rating_id)
REFERENCES rating(rating_id)
ON DELETE CASCADE;

ALTER TABLE note_rating
ADD CONSTRAINT fk_note_rating_note
FOREIGN KEY (note_id)
REFERENCES note(note_id)
ON DELETE CASCADE;

ALTER TABLE gig_rating
ADD CONSTRAINT fk_gig_rating_rating
FOREIGN KEY (rating_id)
REFERENCES rating(rating_id)
ON DELETE CASCADE;

ALTER TABLE gig_rating
ADD CONSTRAINT fk_gig_rating_gig
FOREIGN KEY (gig_id)
REFERENCES gig(gig_id)
ON DELETE CASCADE;

ALTER TABLE student_rating
ADD CONSTRAINT fk_student_rating_rating
FOREIGN KEY (rating_id)
REFERENCES rating(rating_id)
ON DELETE CASCADE;

ALTER TABLE student_rating
ADD CONSTRAINT fk_student_rating_student
FOREIGN KEY (student_id)
REFERENCES student(student_id)
ON DELETE CASCADE;