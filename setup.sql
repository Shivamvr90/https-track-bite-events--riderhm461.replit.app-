-- TrackBite EventsHub — Database Setup
-- Run this once against your PostgreSQL database before starting the server.
-- Command: psql $DATABASE_URL -f setup.sql

CREATE TABLE IF NOT EXISTS "demo_requests" (
  "id"         SERIAL PRIMARY KEY,
  "name"       TEXT    NOT NULL,
  "email"      TEXT    NOT NULL,
  "phone"      TEXT    NOT NULL,
  "company"    TEXT    NOT NULL,
  "event_type" TEXT    NOT NULL,
  "message"    TEXT,
  "created_at" TIMESTAMP DEFAULT NOW() NOT NULL
);
