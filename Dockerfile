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
FROM rust:slim-stretch
WORKDIR /wegift
COPY --from=builder /wegift/target/release/wegift .
USER 1000
ENTRYPOINT ["./wegift"]