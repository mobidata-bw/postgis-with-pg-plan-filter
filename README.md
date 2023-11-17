# PostGIS Docker image with [`pg_plan_filter`](https://github.com/pgexperts/pg_plan_filter)

This repo just contains a Dockerfile to build a **PostgreSQL Docker image with [PostGIS](https://www.postgis.net) and [`pg_plan_filter`](https://github.com/pgexperts/pg_plan_filter)**, as well as a GitHub Actions CI config to automatically publish it.

*Note:* The `pg_plan_filter` project does not provide a `.control` file & `.sql` initialization script, so we add it manually, so that `pg_plan_filter` can then be loaded using `CREATE EXTENSION plan_filter`.
