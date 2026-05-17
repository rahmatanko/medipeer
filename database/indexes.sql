SET search_path TO medipeer;


-- ･ ｡ﾟ☆: *.☽ .* Indexes for faster search and joins ･ ｡ﾟ☆: *.☽ .* --

CREATE INDEX idx_student_department
ON student(student_department);

CREATE INDEX idx_course_department
ON course(course_department);

CREATE INDEX idx_course_code
ON course(course_code);

CREATE INDEX idx_note_course
ON note(course_id);

CREATE INDEX idx_note_author
ON note(author_id);

CREATE INDEX idx_note_title
ON note(note_title);

CREATE INDEX idx_note_price
ON note(note_price);

CREATE INDEX idx_note_tag_name
ON note_tag(tag_name);

CREATE INDEX idx_gig_course
ON gig(course_id);

CREATE INDEX idx_gig_student
ON gig(student_id);

CREATE INDEX idx_gig_service_type
ON gig(service_type);

CREATE INDEX idx_gig_status
ON gig(gig_status);

CREATE INDEX idx_study_group_course
ON study_group(course_id);

CREATE INDEX idx_transaction_buyer
ON transaction(buyer_id);

CREATE INDEX idx_transaction_note
ON transaction(note_id);

CREATE INDEX idx_transaction_gig
ON transaction(gig_id);

CREATE INDEX idx_rating_giver
ON rating(giver_id);

CREATE INDEX idx_rating_score
ON rating(score);

-- Full-text search indexes for simple Phase 1 search readiness
CREATE INDEX idx_note_search
ON note
USING GIN (
    to_tsvector('english', note_title || ' ' || COALESCE(note_description, ''))
);

CREATE INDEX idx_gig_search
ON gig
USING GIN (
    to_tsvector('english', gig_name || ' ' || COALESCE(gig_description, ''))
);

CREATE INDEX idx_group_search
ON study_group
USING GIN (
    to_tsvector('english', group_name || ' ' || COALESCE(description, ''))
);