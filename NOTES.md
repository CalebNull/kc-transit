# KCATA GTFS Feed Notes

Feed version `July 2026_20260827` · Valid 2026-07-12 → 2026-10-03
Source: https://ridekc.org/static-gtfs · Exported from Trapeze (KCATA's scheduling system)

## Row counts
| File | Records |
|---|---|
| routes.txt | 30 |
|stops.txt | 2,300 |
| trips.txt | 5,642 |
| shapes.txt | 42,812 points → 95 shapes |
| stop_times.txt | 198,370 |
| calendar.txt | 3 |
| calendar_dates.txt | 84 |

## Findings

### Feed expiry
- Feed is only valid -3 months; new versions replace it.
- **Impact:** loader must be re-runnable; store `feed_version` + dates in a `feed_info` table.

### Route colors
- 26 of 30 routes are `C0C0C0` (silver). only 23, 50 (green), 210 (purple), Streetcar (blue) have real colors.
- **Impact:** store raw color, but apply my own palette for display when color is `C0C0C0`.

### Route IDs
- `route_id` ≠ public name: 2 = TMAX, 3 = PMAX, 601 = STCR.
- Quirks: route 50 has `route_desc = 1`; route 21 spelled "Clevland".
- **Impact:** key by `route_id` (as text), display `route_short_name`.

### Stops
- `location_type` blank for all → no stations.
- `wheelchair_boarding` = 0 for all → means "no info", not "inaccessible".
- 14 duplicate names (opposite sides of the street).
- Bounding box: lat 38.88–39.31, lon −94.83 to −94.40.
- **Impact:** key by `stop_id`; never show stops as inaccessible; use bbox to validate loader.

### Shapes
- 95 shapes, all referenced; no trip missing a shape.
- Most routes have 2 (one per direction); streetcar has 18.
- Export log has 14 "lost shape" warnings → possible gaps in lines.

### Stop times (Milestone 2)
- Single-digit hours have a leading space (`" 5:30:00"`).
- Hours go to 25:xx (after-midnight service).
- Only 63,470 rows are timepoints; the rest are interpolated.
- **Impact:** trim times; store as seconds-since-midnight `int`, not `time`;
  measure delays against timepoints.

### Calendar
- 3 base services: weekday / Saturday / Sunday.
- Labor Day: weekday removed, Sunday service added.
- Streetcar runs ONLY on 7 services defined in `calendar_dates`.
- **Impact:** no FK from `service_id` to `calendar`; "what runs today" must check both tables.

### Export log (google.log)
- 371 errors: stops 5000, 5075, 5076 had no abbreviation and were silently
  removed from trips; they're not in stops.txt.
- **Impact:** some trips skip real-world stops — document as a data limitation.