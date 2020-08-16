FROM rustlang/rust:nightly as builder

WORKDIR /wegift

COPY ./Cargo.toml ./Cargo.toml
COPY ./diesel.toml ./diesel.toml
COPY ./Rocket.toml ./Rocket.toml
COPY ./src ./src

RUN cargo install --path .

# Size optimization
RUN strip target/release/wegift

COPY --from=builder /wegift/target/release/wegift .
USER 1000
ENTRYPOINT ["./wegift"]

# Start building the final image
#FROM gcr.io/distroless/cc
#COPY --from=builder /usr/lib/x86_64-linux-gnu/* /usr/lib/x86_64-linux-gnu/
#COPY --from=builder /lib/x86_64-linux-gnu/* /lib/x86_64-linux-gnu/
#WORKDIR /wegift
#COPY --from=builder /wegift/target/release/wegift .
#USER 1000
#ENTRYPOINT ["./wegift"]