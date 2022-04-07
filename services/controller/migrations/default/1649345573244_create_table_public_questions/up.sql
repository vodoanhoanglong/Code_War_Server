CREATE TABLE "public"."questions" ("id" text NOT NULL DEFAULT gen_random_uuid(), "content" text, "answer" json, "isCode" boolean NOT NULL DEFAULT true, "status" text NOT NULL DEFAULT '"active"', "createdAt" timestamptz NOT NULL DEFAULT now(), "createdBy" text, "updatedAt" timestamptz NOT NULL DEFAULT now(), "updatedBy" text, "contestId" text NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("contestId") REFERENCES "public"."contests"("id") ON UPDATE restrict ON DELETE restrict);
