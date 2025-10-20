ARG POSTGIS_IMG=postgis/postgis:16-3.5-alpine@sha256:deef169c7592b42c285ecd6667d1e83c8ebc921c705f14670d7ea7358c71f8e6

FROM $POSTGIS_IMG AS builder

RUN apk add --no-cache \
	# pg_plan_filter uses PostgreSQL's built-in extension Makefile, which seems to want a specific clang version. :/
	clang19 \
	make \
	musl-dev \
	postgresql-dev \
	unzip

WORKDIR /tmp/pg_plan_filter
ADD pg_plan_filter/ .
RUN make

FROM $POSTGIS_IMG

LABEL org.opencontainers.image.title="postgis-with-pg-plan-filter"
LABEL org.opencontainers.image.description="PostGIS Docker image with the pg_plan_filter extension."
LABEL org.opencontainers.image.authors="MobiData-BW IPL contributors <mobidata-bw@nvbw.de>"
LABEL org.opencontainers.image.documentation="https://github.com/mobidata-bw/postgis-with-pg-plan-filter"
LABEL org.opencontainers.image.source="https://github.com/mobidata-bw/postgis-with-pg-plan-filter"
LABEL org.opencontainers.image.licenses="(EUPL-1.2)"

# output of `pg_config --pkglibdir`
ARG modules_dir=/usr/local/lib/postgresql
# output of `pg_config --sharedir`
ARG share_dir=/usr/local/share/postgresql

ADD plan_filter.control "$share_dir/extension/plan_filter.control"
ADD plan_filter--1.0.sql "$share_dir/extension/plan_filter--1.0.sql"
COPY --from=builder /tmp/pg_plan_filter/plan_filter.so "$modules_dir/plan_filter.so"
