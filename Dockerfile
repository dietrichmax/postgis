FROM postgres:16-bullseye

ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.5.2+dfsg-1.pgdg110+1
ENV PGVECTORS_VERSION v0.3.0


RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           # ca-certificates: for accessing remote raster files;
           #   fix: https://github.com/postgis/docker-postgis/issues/307
           ca-certificates \
           wget \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/tensorchord/pgvecto.rs/releases/download/v$PGVECTORS_VERSION/vectors-pg16_$PGVECTORS_VERSION_amd64.deb -P /tmp/
COPY vectors-pg16_$PGVECTORS_VERSION_amd64.deb /tmp/vectors.deb
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb

