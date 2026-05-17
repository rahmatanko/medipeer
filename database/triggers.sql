SET search_path TO medipeer;

-- ･ ｡ﾟ☆: *.☽ .* Update student reputation score ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE FUNCTION update_student_reputation(target_student_id INT)
RETURNS VOID AS $$
DECLARE
    avg_score NUMERIC(4,2);
BEGIN
    SELECT ROUND(AVG(score)::NUMERIC, 2)
    INTO avg_score
    FROM (
        SELECT r.score
        FROM rating r
        JOIN student_rating sr ON r.rating_id = sr.rating_id
        WHERE sr.student_id = target_student_id

        UNION ALL

        SELECT r.score
        FROM rating r
        JOIN note_rating nr ON r.rating_id = nr.rating_id
        JOIN note n ON nr.note_id = n.note_id
        WHERE n.author_id = target_student_id

        UNION ALL

        SELECT r.score
        FROM rating r
        JOIN gig_rating gr ON r.rating_id = gr.rating_id
        JOIN gig g ON gr.gig_id = g.gig_id
        WHERE g.student_id = target_student_id
    ) all_scores;

    UPDATE student
    SET reputation_score = COALESCE(avg_score, 0.00)
    WHERE student_id = target_student_id;
END;
$$ LANGUAGE plpgsql;


-- ･ ｡ﾟ☆: *.☽ .* After NOTE_RATING insert ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE FUNCTION trg_update_note_author_reputation()
RETURNS TRIGGER AS $$
DECLARE
    target_student_id INT;
BEGIN
    SELECT author_id
    INTO target_student_id
    FROM note
    WHERE note_id = NEW.note_id;

    PERFORM update_student_reputation(target_student_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_note_rating_insert
AFTER INSERT ON note_rating
FOR EACH ROW
EXECUTE FUNCTION trg_update_note_author_reputation();


-- ･ ｡ﾟ☆: *.☽ .* After GIG_RATING insert ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE FUNCTION trg_update_gig_owner_reputation()
RETURNS TRIGGER AS $$
DECLARE
    target_student_id INT;
BEGIN
    SELECT student_id
    INTO target_student_id
    FROM gig
    WHERE gig_id = NEW.gig_id;

    PERFORM update_student_reputation(target_student_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_gig_rating_insert
AFTER INSERT ON gig_rating
FOR EACH ROW
EXECUTE FUNCTION trg_update_gig_owner_reputation();


-- ･ ｡ﾟ☆: *.☽ .* After STUDENT_RATING insert ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE FUNCTION trg_update_rated_student_reputation()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM update_student_reputation(NEW.student_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_student_rating_insert
AFTER INSERT ON student_rating
FOR EACH ROW
EXECUTE FUNCTION trg_update_rated_student_reputation();


-- ･ ｡ﾟ☆: *.☽ .* Automatically add creator to study group ･ ｡ﾟ☆: *.☽ .* --

CREATE OR REPLACE FUNCTION trg_add_creator_to_group()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO joins (student_id, group_id, role)
    VALUES (NEW.creator_id, NEW.group_id, 'Creator')
    ON CONFLICT (student_id, group_id) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_study_group_insert
AFTER INSERT ON study_group
FOR EACH ROW
EXECUTE FUNCTION trg_add_creator_to_group();