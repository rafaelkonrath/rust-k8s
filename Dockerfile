FROM rustlang/rust:nightly as builder

WORKDIR /wegift

COPY ./Cargo.toml ./Cargo.toml
COPY ./diesel.toml ./diesel.toml
COPY ./Rocket.toml ./Rocket.toml
COPY ./src ./src

RUN cargo install --path .

# Size optimization
RUN strip target/release/wegift

# Start building the final image
FROM gcr.io/distroless/cc-debian10
RUN apt-get update && apt-get install -y \
    musl-dev \
    musl-tools \
    file \
    openssh-client \
    pkgconf \
    ca-certificates \
    xutils-dev \
    libssl-dev \
    libpq-dev \
    automake \
    autoconf \
    libtool \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /wegift
COPY --from=builder /wegift/target/release/wegift .
USER 1000
ENTRYPOINT ["./wegift"]