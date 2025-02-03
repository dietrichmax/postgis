FROM scratch as nothing
ARG TARGETARCH
FROM tensorchord/pgvecto-rs-binary:16-0.30 as binary

FROM postgres:16-bullseye
COPY --from=binary /pgvecto-rs-binary-release.deb /tmp/vectors.deb
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb

CMD ["postgres", "-c" ,"shared_preload_libraries=vectors.so", "-c", "search_path=\"$user\", public, vectors", "-c", "logging_collector=on"]