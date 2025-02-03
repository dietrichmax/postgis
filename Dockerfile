# Use the PostGIS image as the base
FROM tensorchord/pgvecto-rs:pg16-v0.4.0 as binary

FROM postgis/postgis:16-3.5

COPY --from=binary /pgvecto-rs-release.deb /tmp/vectors.deb
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb

# Change the uid of postgres to 26
RUN usermod -u 26 postgres
USER 26

CMD ["postgres", "-c" ,"shared_preload_libraries=vectors.so", "-c", "search_path=\"$user\", public, vectors", "-c", "logging_collector=on"]