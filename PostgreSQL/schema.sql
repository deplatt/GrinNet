-- Create the users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bio_text TEXT,
    profile_picture TEXT, -- URL or a file path
    salt_for_password TEXT NOT NULL,
    hashed_password TEXT NOT NULL,
    num_of_reports INTEGER DEFAULT 0,
    status VARCHAR(20) NOT NULL CHECK (status IN ('warned', 'banned', 'reported'))
);
-- Create the posts table
CREATE TABLE posts (
    post_id SERIAL PRIMARY KEY,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_of_termination TIMESTAMP,
    post_image TEXT, -- URL or file path
    post_text TEXT,
    post_tags TEXT[], -- array of text for multiple tags
    creator INTEGER NOT NULL,
    FOREIGN KEY (creator) REFERENCES users(id)
);
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
