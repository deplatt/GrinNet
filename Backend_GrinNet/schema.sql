-- Create the users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bio_text TEXT,
    profile_picture TEXT, -- URL or a file path
    num_of_reports INTEGER DEFAULT 0,
    status VARCHAR(20) NOT NULL CHECK (status IN ('warned', 'banned', 'reported', 'nothing'))
);

-- Create the posts table without the check constraint on tags.
CREATE TABLE posts (
    post_id SERIAL PRIMARY KEY,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_of_termination TIMESTAMP,
    post_image TEXT, -- URL or file path
    post_text TEXT,
    post_tags TEXT[] NOT NULL,  -- Must have at least one tag.
    creator INTEGER NOT NULL,
    FOREIGN KEY (creator) REFERENCES users(id)
);

-- Create a trigger function to normalize and validate post_tags.
CREATE OR REPLACE FUNCTION normalize_post_tags() 
RETURNS trigger AS $$
DECLARE
   allowed CONSTANT TEXT[] := ARRAY['sports','culture','games','sepcs','dance','music','food','social','misc'];
   filtered TEXT[];
BEGIN
   -- Convert all tags to lowercase and keep only those that are in the allowed list.
   SELECT array_agg(lower(t))
   INTO filtered
   FROM unnest(NEW.post_tags) AS t
   WHERE lower(t) = ANY (allowed);
   
   -- Ensure at least one allowed tag remains.
   IF filtered IS NULL OR array_length(filtered, 1) < 1 THEN
      RAISE EXCEPTION 'Post must have at least one allowed tag';
   END IF;
   
   NEW.post_tags = filtered;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger to invoke the function before insert or update.
CREATE TRIGGER normalize_post_tags_trigger
BEFORE INSERT OR UPDATE ON posts
FOR EACH ROW
EXECUTE FUNCTION normalize_post_tags();

-- Create the reports table
CREATE TABLE reports (
    report_id SERIAL PRIMARY KEY,
    reported_user INTEGER NOT NULL,
    complaint_text TEXT,
    post_id INTEGER, -- Report should always be about a specific post
    reporter_user INTEGER NOT NULL,
    FOREIGN KEY (reported_user) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (reporter_user) REFERENCES users(id)
);
