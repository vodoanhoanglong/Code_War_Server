CREATE TABLE "public"."results" ("accountId" text NOT NULL, "contestId" text NOT NULL, "questionId" text NOT NULL, "point" double precision NOT NULL, "completionTime" timetz NOT NULL, "status" integer NOT NULL DEFAULT 1, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "created_by" text, "updated_by" text, PRIMARY KEY ("accountId","contestId","questionId") , FOREIGN KEY ("accountId") REFERENCES "public"."account"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("contestId") REFERENCES "public"."contests"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("questionId") REFERENCES "public"."questions"("id") ON UPDATE restrict ON DELETE restrict);
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
CREATE TRIGGER "set_public_results_updated_at"
BEFORE UPDATE ON "public"."results"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_results_updated_at" ON "public"."results" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
