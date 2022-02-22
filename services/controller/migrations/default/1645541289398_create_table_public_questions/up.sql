CREATE TABLE "public"."questions" ("id" text NOT NULL DEFAULT gen_random_uuid(), "content" text NOT NULL, "answer" text NOT NULL, "type" text NOT NULL, "status" integer NOT NULL DEFAULT 1, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "created_by" text, "updated_by" text, "contestId" text NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("contestId") REFERENCES "public"."contests"("id") ON UPDATE restrict ON DELETE restrict);
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_questions_updated_at"
BEFORE UPDATE ON "public"."questions"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_questions_updated_at" ON "public"."questions" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
