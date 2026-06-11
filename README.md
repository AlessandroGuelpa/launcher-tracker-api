# 🚀 Launch Tracker API

REST API that aggregates global orbital launch data from [Launch Library 2](https://thespacedevs.com/llapi), processes it into a local database, and exposes enriched endpoints with statistics, filtering and full-text search that the source API does not provide.

Built as a portfolio project to demonstrate Rails API-only architecture, external API consumption, background job processing, and clean API design.

**Live demo:** _coming soon_
**Swagger docs:** `http://localhost:3000/api-docs` (local) · _production link coming soon_

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Ruby on Rails 8.1 (API-only) |
| Database | MySQL 8 |
| Background Jobs | Sidekiq + Redis |
| HTTP Client | Faraday |
| Serialization | Blueprinter |
| API Docs | rswag (OpenAPI 3.0 / Swagger UI) |
| Testing | RSpec, FactoryBot, Faker |

## Data Source

[Launch Library 2](https://ll.thespacedevs.com/2.3.0/) — community-maintained API covering all orbital launch providers worldwide (SpaceX, CASC, Rocket Lab, Arianespace, ISRO, etc.).

The app syncs data via background jobs and stores it locally, enabling aggregation queries and search that the upstream API doesn't support.

## API Endpoints

### Launches

```
GET /api/v1/launches                    Paginated list with filters
GET /api/v1/launches/:id                Single launch (detailed)
GET /api/v1/launches/upcoming           Future launches sorted by date
GET /api/v1/launches/latest             Most recent completed launch
```

**Query parameters for `/launches`:**

| Param | Type | Description |
|---|---|---|
| `page` | integer | Page number (default: 1) |
| `per_page` | integer | Results per page (default: 20) |
| `q` | string | Full-text search on name and provider |
| `provider` | string | Filter by provider (partial match) |
| `year` | integer | Filter by launch year |
| `success` | boolean | Filter by outcome |
| `rocket_id` | integer | Filter by rocket |

### Rockets

```
GET /api/v1/rockets                     All rockets (filterable by active status)
GET /api/v1/rockets/:id                 Single rocket with aggregate stats
GET /api/v1/rockets/:id/launches        Launches for a specific rocket
```

### Statistics

These endpoints return aggregated data not available from the source API:

```
GET /api/v1/stats/launches_per_year     Launch count grouped by year
GET /api/v1/stats/success_rate          Overall + per-rocket success rates
GET /api/v1/stats/streak                Current consecutive success streak
GET /api/v1/stats/providers             Launch count per provider
```

## Database Schema

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│   rockets    │       │   launches   │       │  launchpads  │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ id           │◄──┐   │ id           │   ┌──►│ id           │
│ external_id  │   │   │ external_id  │   │   │ external_id  │
│ name         │   │   │ name         │   │   │ name         │
│ description  │   │   │ date_utc     │   │   │ full_name    │
│ first_flight │   │   │ success      │   │   │ locality     │
│ active       │   └───│ rocket_id    │   │   │ region       │
│ created_at   │       │ launchpad_id │───┘   │ latitude     │
│ updated_at   │       │ provider_name│       │ longitude    │
└──────────────┘       │ details      │       │ created_at   │
                       │ raw_data     │       │ updated_at   │
                       │ created_at   │       └──────────────┘
                       │ updated_at   │
                       └──────────────┘
```

## Architecture Decisions

**API-only Rails** — No view layer. The frontend is a separate React app that consumes JSON endpoints. This enforces clean separation of concerns and makes the API reusable by any client.

**Local data storage** — Instead of proxying requests to Launch Library 2, the app syncs data into its own database. This enables SQL aggregations (launches per year, success rates, streaks) that would be impossible or impractical against the remote API.

**Versioned namespace (`/api/v1/`)** — Allows introducing breaking changes in `v2` without affecting existing consumers.

**Full-text search with LIKE** — Pragmatic choice for the current data volume (~500 launches). Would migrate to full-text index or Elasticsearch if the dataset grew significantly.

**`raw_data` JSON column** — Stores the complete upstream payload per launch, ensuring no data loss during sync even if the local schema doesn't map every field.

## Run Locally

**Prerequisites:** Ruby 3.x, Rails 8.1, MySQL 8, Redis (for Sidekiq)

```bash
git clone https://github.com/yourusername/launch-tracker-api.git
cd launch-tracker-api

# Dependencies
bundle install

# Environment
cp .env.example .env
# Edit .env with your MySQL credentials

# Database
rails db:create db:migrate

# Seed data from Launch Library 2
rails console
> SyncRocketsJob.perform_now
> SyncLaunchpadsJob.perform_now
> SyncLaunchesJob.perform_now(scope: "previous", limit: 100)
> SyncLaunchesJob.perform_now(scope: "upcoming", limit: 100)

# Start server
rails s
```

API available at `http://localhost:3000/api/v1/`
Swagger UI at `http://localhost:3000/api-docs`

## Example Requests

```bash
# All launches, page 1
curl http://localhost:3000/api/v1/launches?page=1&per_page=5

# Search by name
curl http://localhost:3000/api/v1/launches?q=falcon

# Filter by provider and year
curl "http://localhost:3000/api/v1/launches?provider=SpaceX&year=2025"

# Stats
curl http://localhost:3000/api/v1/stats/launches_per_year
curl http://localhost:3000/api/v1/stats/success_rate

# Next upcoming launch
curl http://localhost:3000/api/v1/launches/upcoming?limit=1
```

## Frontend

The companion React frontend is available at [launch-tracker-frontend](https://github.com/AlessandroGuelpa/launch-tracker-frontend). It consumes this API and provides a mission-control style dashboard with live countdown, search, filtering, and statistics visualization.
