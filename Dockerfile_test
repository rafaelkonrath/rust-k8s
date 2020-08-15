FROM clux/muslrust:nightly

WORKDIR /usr/src/myapp

COPY ./Cargo.toml ./Cargo.toml
COPY ./diesel.toml ./diesel.toml
COPY ./Rocket.toml ./Rocket.toml

COPY ./src ./src

RUN cargo build --release

CMD cargo run