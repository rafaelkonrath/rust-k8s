FROM rustlang/rust:nightly as builder

WORKDIR /home/rust/

# Avoid having to install/build all dependencies by copying
# the Cargo files and making a dummy src/main.rs
COPY Cargo.toml .
COPY Cargo.lock .

# copy your source tree
COPY ./src ./src

##RUN cargo test
RUN cargo build --release

# We need to touch our real main.rs file or else docker will use
# the cached one.
#COPY . .
#RUN touch src/main.rs

#RUN cargo test
#RUN cargo build --release

# Size optimization
RUN strip target/release/wegift

# Start building the final image
FROM alpine:latest
WORKDIR /home/rust/
COPY --from=builder /home/rust/target/release/wegift .
ENTRYPOINT ["./wegift"]