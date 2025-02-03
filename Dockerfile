FROM tensorchord/pgvecto-rs-binary:v0.3.0 as binary

FROM postgres:16-bullseye

ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.5.2+dfsg-1.pgdg110+1

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           # ca-certificates: for accessing remote raster files;
           #   fix: https://github.com/postgis/docker-postgis/issues/307
           ca-certificates \
           \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      && rm -rf /var/lib/apt/lists/*

COPY --from=binary /pgvecto-rs-binary-release.deb /tmp/vectors.deb
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb
#RUN mkdir -p /docker-entrypoint-initdb.d
#COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
#COPY ./update-postgis.sh /usr/local/bin