-- Up Migration
CREATE EXTENSION IF NOT EXISTS postgis;
-- Which feed version is loaded. One row per load.
CREATE TABLE feed_info (
  feed_version text PRIMARY KEY,
  start_date date NOT NULL,
  end_date date NOT NULL,
  loaded_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE routes (
  route_id text PRIMARY KEY,
  short_name text,
  long_name text,
  route_type smallint NOT NULL,
  color text CHECK (color ~ '^[0-9A-Fa-f]{6}$'),
  text_color text CHECK (text_color ~ '^[0-9A-Fa-f]{6}$')
);
CREATE TABLE stops (
  stop_id text PRIMARY KEY,
  stop_code text,
  stop_name text NOT NULL,
  location_type smallint NOT NULL DEFAULT 0,
  parent_station text,
  wheelchair_boarding smallint NOT NULL DEFAULT 0,
  -- 0 = no info, NOT "inaccessible"
  geom geography(Point, 4326) NOT NULL
);
CREATE INDEX stops_geom_gist ON stops USING GIST (geom);
CREATE TABLE calendar (
  service_id text PRIMARY KEY,
  monday boolean NOT NULL,
  tuesday boolean NOT NULL,
  wednesday boolean NOT NULL,
  thursday boolean NOT NULL,
  friday boolean NOT NULL,
  saturday boolean NOT NULL,
  sunday boolean NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL
);
-- Not FK to calendar: streetcar services exist ONLY here.
CREATE TABLE calendar_dates (
  service_id text NOT NULL,
  date date NOT NULL,
  exception_type smallint NOT NULL CHECK (exception_type IN (1, 2)),
  -- 1 = added, 2 = removed
  PRIMARY KEY (service_id, date)
);
CREATE UNLOGGED TABLE shape_points (
  shape_id text NOT NULL,
  seq integer NOT NULL,
  lat double precision NOT NULL,
  lon double precision NOT NULL,
  PRIMARY KEY (shape_id, seq)
);
CREATE TABLE shapes (
  shape_id text PRIMARY KEY,
  geom geography(LineString, 4326) NOT NULL
);
CREATE TABLE trips (
  trip_id text PRIMARY KEY,
  route_id text NOT NULL REFERENCES routes (route_id),
  service_id text NOT NULL,
  -- no FK on purpose (see calendar_dates)
  headsign text,
  direction_id smallint CHECK (direction_id IN (0, 1)),
  block_id text,
  shape_id text REFERENCES shapes (shape_id)
);
CREATE INDEX trips_route_id_idx ON trips (route_id);
CREATE INDEX trips_shape_id_idx ON trips (shape_id);
CREATE INDEX trips_service_id_idx ON trips (service_id);
-- Down Migration
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS shapes;
DROP TABLE IF EXISTS shape_points;
DROP TABLE IF EXISTS calendar_dates;
DROP TABLE IF EXISTS calendar;
DROP TABLE IF EXISTS stops;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS feed_info;