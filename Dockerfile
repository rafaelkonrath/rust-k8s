# select build image
FROM clux/muslrust:nightly as build

# create a new empty shell project
RUN USER=root cargo new --bin my_project
WORKDIR /my_project

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/my_project*
RUN cargo build --release


# our final base
FROM clux/muslrust:nightly

# copy the build artifact from the build stage
COPY --from=build /my_project/target/release/my_project .

# set the startup command to run your binary
CMD ["./my_project"]