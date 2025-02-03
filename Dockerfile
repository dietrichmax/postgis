# Use the official PostgreSQL 16 image as the base image
FROM postgres:16

# Install required dependencies for PostGIS and pgvector
RUN apt-get update \
    && apt-get install -y \
    postgresql-16-postgis-3 \
    build-essential \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install pgvector-rs v0.3.0 from source (requires Rust toolchain)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && source $HOME/.cargo/env \
    && git clone https://github.com/pgvector/pgvector-rs.git \
    && cd pgvector-rs \
    && git checkout v0.3.0 \
    && cargo build --release \
    && cargo install --path .

# Ensure the PostGIS extension is set up
RUN echo "CREATE EXTENSION IF NOT EXISTS postgis;" > /docker-entrypoint-initdb.d/postgis.sql

# Optional: Initialize pgvector (if needed)
RUN echo "CREATE EXTENSION IF NOT EXISTS pgvector;" > /docker-entrypoint-initdb.d/pgvector.sql
