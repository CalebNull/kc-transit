# KC Transit Reliability

How reliable is Kansas City's bus system? This project collects KCATA's
transit data continuously and turns it into rider-facing answers: how late your
route usually runs, at your stop, at your time of day, and how likely a delay is.
Unlike same-day dashboards, it stores real-time data long-term to measure
reliability over weeks and months.

## Stack

- **Frontend:** Next.js, shadcn/ui, MapLibre
- **API:** Node.js + TypeScript (Fastify)
- **Database:** PostgreSQL + PostGIS (Docker)
- **Data:** KCATA GTFS static feed (https://ridekc.org/open-data/)

## Getting started

    cp .env.example .env
    docker compose up -d
    npm install
    npm run migrate up

## Milestones

### Milestone 1 — Static network map
- [x] Repo setup
- [x] PostGIS in Docker
- [x] Explore GTFS feed ([NOTES.md](NOTES.md))
- [ ] Schema migration
- [ ] GTFS loader
- [ ] `/routes` and `/stops` API
- [ ] Map frontend

### Milestone 2 — Real-time collection
### Milestone 3 — Reliability stats & prediction

## Data limitations

- Most routes have no real color in the GTFS feed; display colors are assigned by this app.
- Some stops are missing from trips due to errors in KCATA's export (see NOTES.md).