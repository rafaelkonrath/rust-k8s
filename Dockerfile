# select build image
FROM rustlang/rust:nightly as builder

WORKDIR /wegift

# copy over your manifests
COPY ./Cargo.toml ./Cargo.toml
COPY ./diesel.toml ./diesel.toml
COPY ./Rocket.toml ./Rocket.toml

# create a new empty shell project
#RUN USER=root cargo build --release

# copy your source tree
COPY ./src ./src

# build for release

RUN cargo build --release
RUN rm ./target/release/deps/wegift*


# our final base
FROM clux/muslrust:nightly

# copy the build artifact from the build stage
COPY --from=builder /wegift/target/release/wegift .

# set the startup command to run your binary
CMD ["./wegift"]