SET search_path TO medipeer;


-- ･ ｡ﾟ☆: *.☽ .* STUDENT ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(150) NOT NULL UNIQUE,
    student_department VARCHAR(100) NOT NULL,
    graduation_year INT,
    reputation_score NUMERIC(4,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ･ ｡ﾟ☆: *.☽ .* COURSE ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE course (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(150) NOT NULL,
    course_department VARCHAR(100) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    instructor VARCHAR(100) NOT NULL
);


-- ･ ｡ﾟ☆: *.☽ .* ENROLLS_IN ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE enrolls_in (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_year INT NOT NULL,
    PRIMARY KEY (student_id, course_id)
);


-- ･ ｡ﾟ☆: *.☽ .* NOTE ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE note (
    note_id SERIAL PRIMARY KEY,
    course_id INT NOT NULL,
    author_id INT NOT NULL,
    note_title VARCHAR(150) NOT NULL,
    note_description TEXT,
    note_price NUMERIC(8,2) NOT NULL DEFAULT 0.00,
    file_path VARCHAR(255) NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ･ ｡ﾟ☆: *.☽ .* NOTE_TAG ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE note_tag (
    note_id INT NOT NULL,
    tag_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (note_id, tag_name)
);


-- ･ ｡ﾟ☆: *.☽ .* CONTENT_PROTECTION_LOG ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE content_protection_log (
    log_id SERIAL PRIMARY KEY,
    note_id INT NOT NULL,
    watermark_status VARCHAR(30) NOT NULL,
    plagiarism_result VARCHAR(30) NOT NULL,
    content_fingerprint_data TEXT NOT NULL,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ･ ｡ﾟ☆: *.☽ .* STUDY_GROUP ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE study_group (
    group_id SERIAL PRIMARY KEY,
    course_id INT NOT NULL,
    creator_id INT NOT NULL,
    group_name VARCHAR(120) NOT NULL,
    description TEXT,
    max_members INT NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ･ ｡ﾟ☆: *.☽ .* JOINS ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE joins (
    student_id INT NOT NULL,
    group_id INT NOT NULL,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role VARCHAR(30) NOT NULL DEFAULT 'Member',
    PRIMARY KEY (student_id, group_id)
);


-- ･ ｡ﾟ☆: *.☽ .* GIG ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE gig (
    gig_id SERIAL PRIMARY KEY,
    course_id INT NOT NULL,
    student_id INT NOT NULL,
    gig_name VARCHAR(150) NOT NULL,
    gig_description TEXT,
    gig_price NUMERIC(8,2) NOT NULL,
    gig_status VARCHAR(30) NOT NULL DEFAULT 'Open',
    service_type VARCHAR(50) NOT NULL,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ･ ｡ﾟ☆: *.☽ .* TRANSACTION ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE transaction (
    transaction_id SERIAL PRIMARY KEY,
    buyer_id INT NOT NULL,
    note_id INT,
    gig_id INT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(8,2) NOT NULL,
    payment_status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    payment_method VARCHAR(50) NOT NULL
);


-- ･ ｡ﾟ☆: *.☽ .* RATING ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE rating (
    rating_id SERIAL PRIMARY KEY,
    giver_id INT NOT NULL,
    score INT NOT NULL,
    comment TEXT,
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ･ ｡ﾟ☆: *.☽ .* NOTE_RATING ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE note_rating (
    rating_id INT PRIMARY KEY,
    note_id INT NOT NULL
);


-- ･ ｡ﾟ☆: *.☽ .* GIG_RATING ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE gig_rating (
    rating_id INT PRIMARY KEY,
    gig_id INT NOT NULL
);


-- ･ ｡ﾟ☆: *.☽ .* STUDENT_RATING ･ ｡ﾟ☆: *.☽ .* --
CREATE TABLE student_rating (
    rating_id INT PRIMARY KEY,
    student_id INT NOT NULL
);