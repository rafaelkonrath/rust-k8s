FROM clux/muslrust

WORKDIR /wegift
##RUN rustup target add x86_64-unknown-linux-musl

##RUN USER=root cargo build --release wegift
##WORKDIR /usr/src/wegift
# Avoid having to install/build all dependencies by copying
# the Cargo files and making a dummy src/main.rs
COPY ./Cargo.toml ./Cargo.toml
COPY ./diesel.toml ./diesel.toml
COPY ./Rocket.toml ./Rocket.toml
##RUN cargo build --release

# copy your source tree
COPY ./src ./src

##RUN cargo test
##RUN cargo build --release
RUN RUSTFLAGS=-Clinker=musl-gcc cargo install --release target=x86_64-unknown-linux-musl


# We need to touch our real main.rs file or else docker will use
# the cached one.
#COPY . .
#RUN touch src/main.rs

#RUN cargo test
#RUN cargo build --release

# Size optimization
RUN strip target/release/wegift

# Start building the final image
FROM clux/muslrust
WORKDIR /wegift
COPY --from=builder /wegift/target/release/wegift .
USER 1000
ENTRYPOINT ["./wegift"]