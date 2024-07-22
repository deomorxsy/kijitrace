FROM rust:1.77.1-alpine3.18 as builder
WORKDIR /app

COPY . .
COPY .env.docker .env
RUN apk update && apk add --upgrade "pkgconf" "openssl-dev" && \
    apk add --no-cache musl-dev && \
    rustup component add rustfmt && \
    rustup component add clippy-preview && \
    cargo install --path .

CMD ["./target/release/app"]


FROM alpine:3.18 as relay
WORKDIR /app

# Create a non-root user and group
RUN addgroup -S appuser && \
    adduser -S -G appuser -u 1001 appuser

# will work with others, but not wasm-bindgen. Use trunk or others
COPY --from=builder /usr/local/cargo/bin/client /usr/local/bin/app
COPY --from=builder ["/app/index.html", "/app/Cargo.toml", "/app/Cargo.lock", "/app/dist/", "/app/.env", "/app/src/", "."]
COPY --from=builder /app/src/ ./src/

# change ownership of files to enable rootless exec
RUN chown -R appuser:appuser /app

# switch to the non-root user
USER appuser

#EXPOSE 8081
CMD ["./app"]

