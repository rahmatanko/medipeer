SET search_path TO medipeer;

-- ･ ｡ﾟ☆: *.☽ .* Creates a completed note transaction ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE PROCEDURE purchase_note(
    p_buyer_id INT,
    p_note_id INT,
    p_payment_method VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price NUMERIC(8,2);
BEGIN
    SELECT note_price
    INTO v_price
    FROM note
    WHERE note_id = p_note_id;

    IF v_price IS NULL THEN
        RAISE EXCEPTION 'Note does not exist.';
    END IF;

    INSERT INTO transaction (
        buyer_id,
        note_id,
        gig_id,
        amount,
        payment_status,
        payment_method
    )
    VALUES (
        p_buyer_id,
        p_note_id,
        NULL,
        v_price,
        'Completed',
        p_payment_method
    );
END;
$$;


-- ･ ｡ﾟ☆: *.☽ .* Creates a new academic gig ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE PROCEDURE create_gig(
    p_course_id INT,
    p_student_id INT,
    p_gig_name VARCHAR,
    p_gig_description TEXT,
    p_gig_price NUMERIC,
    p_service_type VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO gig (
        course_id,
        student_id,
        gig_name,
        gig_description,
        gig_price,
        gig_status,
        service_type
    )
    VALUES (
        p_course_id,
        p_student_id,
        p_gig_name,
        p_gig_description,
        p_gig_price,
        'Open',
        p_service_type
    );
END;
$$;


-- ･ ｡ﾟ☆: *.☽ .* Adds a student to a study group if capacity allows ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE PROCEDURE join_study_group(
    p_student_id INT,
    p_group_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_max_members INT;
    v_current_members INT;
BEGIN
    SELECT max_members
    INTO v_max_members
    FROM study_group
    WHERE group_id = p_group_id;

    IF v_max_members IS NULL THEN
        RAISE EXCEPTION 'Study group does not exist.';
    END IF;

    SELECT COUNT(*)
    INTO v_current_members
    FROM joins
    WHERE group_id = p_group_id;

    IF v_current_members >= v_max_members THEN
        RAISE EXCEPTION 'Study group is already full.';
    END IF;

    INSERT INTO joins (
        student_id,
        group_id,
        role
    )
    VALUES (
        p_student_id,
        p_group_id,
        'Member'
    )
    ON CONFLICT (student_id, group_id)
    DO NOTHING;
END;
$$;


-- ･ ｡ﾟ☆: *.☽ .* Manually recalculates reputation for one student ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE PROCEDURE calculate_reputation(
    p_student_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM update_student_reputation(p_student_id);
END;
$$;


-- ･ ｡ﾟ☆: *.☽ .* Inserts a rating and connects it to a note ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE PROCEDURE rate_note(
    p_giver_id INT,
    p_note_id INT,
    p_score INT,
    p_comment TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rating_id INT;
BEGIN
    INSERT INTO rating (giver_id, score, comment)
    VALUES (p_giver_id, p_score, p_comment)
    RETURNING rating_id INTO v_rating_id;

    INSERT INTO note_rating (rating_id, note_id)
    VALUES (v_rating_id, p_note_id);
END;
$$;


-- ･ ｡ﾟ☆: *.☽ .* Inserts a rating and connects it to a gig ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE PROCEDURE rate_gig(
    p_giver_id INT,
    p_gig_id INT,
    p_score INT,
    p_comment TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rating_id INT;
BEGIN
    INSERT INTO rating (giver_id, score, comment)
    VALUES (p_giver_id, p_score, p_comment)
    RETURNING rating_id INTO v_rating_id;

    INSERT INTO gig_rating (rating_id, gig_id)
    VALUES (v_rating_id, p_gig_id);
END;
$$;


-- ･ ｡ﾟ☆: *.☽ .* Inserts a rating and connects it to a student ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE PROCEDURE rate_student(
    p_giver_id INT,
    p_student_id INT,
    p_score INT,
    p_comment TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rating_id INT;
BEGIN
    INSERT INTO rating (giver_id, score, comment)
    VALUES (p_giver_id, p_score, p_comment)
    RETURNING rating_id INTO v_rating_id;

    INSERT INTO student_rating (rating_id, student_id)
    VALUES (v_rating_id, p_student_id);
END;
$$;