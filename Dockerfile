FROM rustlang/rust:nightly as builder

WORKDIR /usr/src/
RUN rustup target add x86_64-unknown-linux-musl

RUN USER=root cargo new wegift
WORKDIR /usr/src/wegift
# Avoid having to install/build all dependencies by copying
# the Cargo files and making a dummy src/main.rs
COPY Cargo.toml Cargo.lock ./
RUN cargo build --release

# copy your source tree
COPY ./src ./src

##RUN cargo test
##RUN cargo build --release
RUN cargo install --target x86_64-unknown-linux-musl --path .

# We need to touch our real main.rs file or else docker will use
# the cached one.
#COPY . .
#RUN touch src/main.rs

#RUN cargo test
#RUN cargo build --release

# Size optimization
RUN strip target/release/wegift

# Start building the final image
FROM gcr.io/distroless/cc-debian10
WORKDIR /home/rust/
COPY --from=builder /usr/src/wegift/target/release/wegift .
USER 1000
ENTRYPOINT ["./wegift"]