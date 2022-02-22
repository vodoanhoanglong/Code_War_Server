CREATE TABLE "public"."contests" ("id" text NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "des" text NOT NULL, "startDate" timestamptz NOT NULL, "endDate" timestamptz NOT NULL, "logo" text, "status" integer NOT NULL DEFAULT 1, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "created_by" text, "updated_by" text, PRIMARY KEY ("id") );
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
CREATE TRIGGER "set_public_contests_updated_at"
BEFORE UPDATE ON "public"."contests"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_contests_updated_at" ON "public"."contests" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
