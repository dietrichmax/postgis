# Use the PostGIS image as the base
FROM postgis/postgis:17-3.5

# Install necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       wget \
       git \
       postgresql-server-dev-17 \
    # Clean up to reduce layer size
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    # Clean up unnecessary files
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-17 libpq-dev wget git \
    && rm -rf /tmp/pgvector

# Copy initialization scripts
#COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/