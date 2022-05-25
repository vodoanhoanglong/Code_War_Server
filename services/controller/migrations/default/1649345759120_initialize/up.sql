CREATE DOMAIN email AS TEXT
    CHECK (
        VALUE ~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
        );

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;


CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
    RETURNS TRIGGER AS
$$
DECLARE
    _new record;
BEGIN
    _new := NEW;
    _new."updatedAt" = NOW();
    RETURN _new;
END;
$$ LANGUAGE plpgsql;


--------------------------------------------------
-- TABLE public.account
--------------------------------------------------
CREATE TABLE "public"."account"
(
    "id"          TEXT        NOT NULL DEFAULT gen_random_uuid(),
    "email"       email,
    "fullName"    TEXT,
    "password"    TEXT,
    "avatarUrl"   TEXT,
    "role"        TEXT        NOT NULL DEFAULT 'user',
    "birthday"    DATE,
    "gender"      TEXT,
    "hashedToken" TEXT,
    "alias"       TEXT,
    "status"      TEXT        NOT NULL DEFAULT 'active',
    "createdAt"   TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updatedAt"   TIMESTAMPTZ NOT NULL DEFAULT now(),
    "createdBy"   TEXT        NULL,
    "updatedBy"   TEXT        NULL,
    PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX account_email_unique
    ON "public"."account" (email);

CREATE TRIGGER "account_set_current_timestamp_updated_at"
    BEFORE INSERT OR UPDATE
    ON "public"."account"
    FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();

--------------------------------------------------
-- END TABLE public.account
--------------------------------------------------
CREATE TABLE "public"."contests"
(
    "id"        text        NOT NULL DEFAULT gen_random_uuid(),
    "name"      text        NOT NULL,
    "des"       text,
    "startDate" timestamptz,
    "endDate"   timestamptz,
    "time"      integer,
    "logoUrl"   text,
    "status"    text        NOT NULL DEFAULT 'active',
    "createdAt" timestamptz NOT NULL DEFAULT now(),
    "createdBy" text,
    "updatedAt" timestamptz NOT NULL DEFAULT now(),
    "updatedBy" text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("createdBy") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict,
    UNIQUE ("name")
);

CREATE TABLE "public"."courses"
(
    "id"        text        NOT NULL DEFAULT gen_random_uuid(),
    "name"      text        NOT NULL,
    "des"       text,
    "image"     text,
    "status"    text        NOT NULL DEFAULT 'active',
    "createdAt" timestamptz NOT NULL DEFAULT now(),
    "createdBy" text,
    "updatedAt" timestamptz NOT NULL DEFAULT now(),
    "updatedBy" text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("createdBy") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict,
    UNIQUE ("name")
);

CREATE TABLE "public"."concepts"
(
    "id"        text        NOT NULL DEFAULT gen_random_uuid(),
    "name"      text        NOT NULL,
    "des"       text,
    "image"     text,
    "priority"  integer     NOT NULL,
    "courseId"  text        NOT NULL,
    "status"    text        NOT NULL DEFAULT 'active',
    "createdAt" timestamptz NOT NULL DEFAULT now(),
    "createdBy" text,
    "updatedAt" timestamptz NOT NULL DEFAULT now(),
    "updatedBy" text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("courseId") REFERENCES "public"."courses" ("id") ON UPDATE restrict ON DELETE restrict,
    UNIQUE ("name")
);

CREATE TABLE "public"."concept_learned"
(
    "id"        text        NOT NULL DEFAULT gen_random_uuid(),
    "conceptId" text        NOT NULL,
    "accountId" text        NOT NULL,
    "status"    text        NOT NULL DEFAULT 'active',
    "createdAt" timestamptz NOT NULL DEFAULT now(),
    "createdBy" text,
    "updatedAt" timestamptz NOT NULL DEFAULT now(),
    "updatedBy" text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("conceptId") REFERENCES "public"."concepts" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("accountId") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict
);

CREATE TABLE "public"."challenges"
(
    "id"        text        NOT NULL DEFAULT gen_random_uuid(),
    "name"      text        NOT NULL,
    "des"       text,
    "image"     text,
    "priority"  serial,
    "startDate" timestamptz,
    "endDate"   timestamptz,
    "status"    text        NOT NULL DEFAULT 'active',
    "createdAt" timestamptz NOT NULL DEFAULT now(),
    "createdBy" text,
    "updatedAt" timestamptz NOT NULL DEFAULT now(),
    "updatedBy" text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("createdBy") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict,
    UNIQUE ("name")
);

CREATE TABLE "public"."exercises"
(
    "id"          text        NOT NULL DEFAULT gen_random_uuid(),
    "name"        text,
    "des"         text,
    "level"       integer,
    "image"       text,
    "metadata"    jsonb       NOT NULL DEFAULT jsonb_build_array(),
    "topic"       jsonb       NOT NULL DEFAULT jsonb_build_array(),
    "contestId"   text,
    "conceptId"   text,
    "challengeId" text,
    "status"      text        NOT NULL DEFAULT 'active',
    "createdAt"   timestamptz NOT NULL DEFAULT now(),
    "createdBy"   text,
    "updatedAt"   timestamptz NOT NULL DEFAULT now(),
    "updatedBy"   text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("contestId") REFERENCES "public"."contests" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("challengeId") REFERENCES "public"."challenges" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("conceptId") REFERENCES "public"."concepts" ("id") ON UPDATE restrict ON DELETE restrict
);

CREATE TABLE "public"."blogs"
(
    "id"         text        NOT NULL DEFAULT gen_random_uuid(),
    "title"      text,
    "content"    text,
    "isApproved" boolean     NOT NULL DEFAULT false,
    "status"     text        NOT NULL DEFAULT 'active',
    "createdAt"  Timestamp   NOT NULL DEFAULT now(),
    "createdBy"  text,
    "updatedAt"  timestamptz NOT NULL DEFAULT now(),
    "updatedBy"  text,
    "accountId"  text        NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("accountId") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict
);

CREATE TABLE "public"."discusses"
(
    "id"         text        NOT NULL DEFAULT gen_random_uuid(),
    "floor"      text,
    "title"      text,
    "content"    text,
    "status"     text        NOT NULL DEFAULT 'active',
    "createdAt"  timestamptz   NOT NULL DEFAULT now(),
    "createdBy"  text,
    "updatedAt"  timestamptz NOT NULL DEFAULT now(),
    "updatedBy"  text,
    "exerciseId" text        NOT NULL,
    "blogId"     text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("createdBy") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("exerciseId") REFERENCES "public"."exercises" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("blogId") REFERENCES "public"."blogs" ("id") ON UPDATE restrict ON DELETE restrict
);

CREATE TABLE "public"."exercise_results"
(
    "id"         text        NOT NULL DEFAULT gen_random_uuid(),
    "accountId"  text        NOT NULL,
    "exerciseId" text        NOT NULL,
    "point"      float8,
    "memory"     integer,
    "excuteTime" float8,
    "caseFailed" jsonb       NOT NULL DEFAULT jsonb_build_array(),
    "status"     text        NOT NULL DEFAULT 'active',
    "createdAt"  timestamptz NOT NULL DEFAULT now(),
    "createdBy"  text,
    "updatedAt"  timestamptz NOT NULL DEFAULT now(),
    "updatedBy"  text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("accountId") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("exerciseId") REFERENCES "public"."exercises" ("id") ON UPDATE restrict ON DELETE restrict
);

CREATE TABLE "public"."questions"
(
    "id"        text        NOT NULL DEFAULT gen_random_uuid(),
    "content"   text,
    "answer"    json,
    "isCode"    boolean     NOT NULL DEFAULT true,
    "status"    text        NOT NULL DEFAULT 'active',
    "createdAt" timestamptz NOT NULL DEFAULT now(),
    "createdBy" text,
    "updatedAt" timestamptz NOT NULL DEFAULT now(),
    "updatedBy" text,
    "contestId" text        NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("contestId") REFERENCES "public"."contests" ("id") ON UPDATE restrict ON DELETE restrict
);

CREATE TABLE "public"."contest_results"
(
    "id"             text        NOT NULL DEFAULT gen_random_uuid(),
    "questionId"     text,
    "exerciseId"     text,
    "contestId"      text        NOT NULL,
    "point"          integer,
    "completionTime" integer,
    "status"         text        NOT NULL DEFAULT 'active',
    "createdAt"      timestamptz NOT NULL DEFAULT now(),
    "createdBy"      text,
    "updatedAt"      timestamptz NOT NULL DEFAULT now(),
    "updatedBy"      text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("createdBy") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("contestId") REFERENCES "public"."contests" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("questionId") REFERENCES "public"."questions" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("exerciseId") REFERENCES "public"."exercises" ("id") ON UPDATE restrict ON DELETE restrict
);

CREATE TABLE "public"."discuss_reacts"
(
    "id"        text        NOT NULL DEFAULT gen_random_uuid(),
    "discussId" text        NOT NULL,
    "reactType" text        NOT NULL DEFAULT 'like',
    "status"    text        NOT NULL DEFAULT 'active',
    "createdAt" timestamptz NOT NULL DEFAULT now(),
    "createdBy" text,
    "updatedAt" text        NOT NULL DEFAULT now(),
    "updatedBy" text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("discussId") REFERENCES "public"."discusses" ("id") ON UPDATE restrict ON DELETE restrict,
    FOREIGN KEY ("createdBy") REFERENCES "public"."account" ("id") ON UPDATE restrict ON DELETE restrict,
    UNIQUE ("createdBy", "discussId")
);
