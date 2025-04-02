-- Table: public.users

-- DROP TABLE IF EXISTS public.users;

CREATE TABLE IF NOT EXISTS public.users
(
    id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    username character varying(255) COLLATE pg_catalog."default" NOT NULL,
    creation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    bio_text text COLLATE pg_catalog."default",
    profile_picture text COLLATE pg_catalog."default",
    salt_for_password text COLLATE pg_catalog."default" NOT NULL,
    hashed_password text COLLATE pg_catalog."default" NOT NULL,
    num_of_reports integer DEFAULT 0,
    status character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_username_key UNIQUE (username),
    CONSTRAINT users_status_check CHECK (status::text = ANY (ARRAY['warned'::character varying, 'banned'::character varying, 'reported'::character varying, 'nothing'::character varying]::text[]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;



-- Table: public.posts

-- DROP TABLE IF EXISTS public.posts;

CREATE TABLE IF NOT EXISTS public.posts
(
    post_id integer NOT NULL DEFAULT nextval('posts_post_id_seq'::regclass),
    date_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    date_of_termination timestamp without time zone,
    post_image text COLLATE pg_catalog."default",
    post_text text COLLATE pg_catalog."default",
    post_tags text[] COLLATE pg_catalog."default",
    creator integer NOT NULL,
    CONSTRAINT posts_pkey PRIMARY KEY (post_id),
    CONSTRAINT posts_creator_fkey FOREIGN KEY (creator)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.posts
    OWNER to postgres;



-- Table: public.reports

-- DROP TABLE IF EXISTS public.reports;

CREATE TABLE IF NOT EXISTS public.reports
(
    report_id integer NOT NULL DEFAULT nextval('reports_report_id_seq'::regclass),
    reported_user integer NOT NULL,
    complaint_text text COLLATE pg_catalog."default",
    post_id integer,
    reporter_user integer NOT NULL,
    CONSTRAINT reports_pkey PRIMARY KEY (report_id),
    CONSTRAINT reports_post_id_fkey FOREIGN KEY (post_id)
        REFERENCES public.posts (post_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT reports_reported_user_fkey FOREIGN KEY (reported_user)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT reports_reporter_user_fkey FOREIGN KEY (reporter_user)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.reports
    OWNER to postgres;
