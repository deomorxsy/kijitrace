FROM debian:12.6 as font-builder

WORKDIR /app
ARG PKG=/app/packages

RUN apt-get update && \
    apt-get install -y git wget  mime-support libexpat1 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libtirpc3 && \
    mkdir -p $PKG && \
    wget -P $PKG http://ftp.debian.org/debian/pool/main/libf/libffi/libffi7_3.3-6_amd64.deb && \
    wget -P $PKG http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb && \
    wget -P $PKG http://ftp.debian.org/debian/pool/main/p/python2.7/libpython2.7-minimal_2.7.18-8+deb11u1_amd64.deb && \
    wget -P $PKG http://ftp.debian.org/debian/pool/main/p/python2.7/python2.7-minimal_2.7.18-8+deb11u1_amd64.deb && \
    wget -P $PKG http://ftp.debian.org/debian/pool/main/p/python2.7/libpython2.7-stdlib_2.7.18-8+deb11u1_amd64.deb && \
    wget -P $PKG http://ftp.debian.org/debian/pool/main/p/python2.7/python2.7_2.7.18-8+deb11u1_amd64.deb


RUN dpkg -i $PKG/libffi7_3.3-6_amd64.deb \
            $PKG/libssl1.1_1.1.1w-0+deb11u1_amd64.deb \
            $PKG/libpython2.7-minimal_2.7.18-8+deb11u1_amd64.deb \
            $PKG/python2.7-minimal_2.7.18-8+deb11u1_amd64.deb \
            $PKG/libpython2.7-stdlib_2.7.18-8+deb11u1_amd64.deb \
            $PKG/python2.7_2.7.18-8+deb11u1_amd64.deb

RUN apt-get install -y python3 python3.11-venv python3-pip

RUN mkdir -p /app/roboto-src && \
    cd /app/roboto-src && \
    git clone https://github.com/google/roboto.git
    #python3 -m ensurepip --default-pip && \
    #pip3 install --upgrade pip && \
    #pip3 install --user virtualenv

RUN python3 -m venv /app/roboto-env && \
    /app/roboto-env/bin/pip install --upgrade pip && \
    /app/roboto-env/bin/pip install virtualenv

RUN apt-get install bash


#python3 virtualenv
RUN /app/roboto-env/bin/virtualenv --python=/bin/python2.7 /app/roboto-src/roboto-env && \
    /app/roboto-src/roboto-env/bin/pip install -r /app/roboto-src/roboto/requirements.txt && \
    #source roboto-env/bin/activate && \
    cd /app/roboto-src/roboto && \
    #pip install -r requirements.txt && \
    make

ENTRYPOINT ["/bin/bash", "--posix"]


FROM rust:1.79.0-alpine3.20 as builder
WORKDIR /app

COPY . .
#COPY .env.docker .env
COPY --from=font-builder /app/roboto-src/roboto/src/hinted/*.ttf /app/resources/

RUN apk update && apk add --upgrade build-base "pkgconf" openssl=3.3.1-r3 "openssl-dev" && \
    apk add --no-cache build-base musl-dev && \
    #apk add font-terminus font-inconsolata font-dejavu font-noto && \
    #apk add font-noto-cjk font-awesome font-noto-extra font-terminus && \
    #apk add font-noto font-noto-thai font-noto-tibetan font-ipa && \
    #apk add font-sony-misc font-jis-misc ttf-roboto && \
    rustup component add rustfmt && \
    rustup component add clippy-preview && \
    cargo install --path .

CMD ["./target/release/app"]


#FROM alpine:3.18 as relay
#WORKDIR /app

# Create a non-root user and group
#RUN addgroup -S appuser && \
#    adduser -S -G appuser -u 1001 appuser

# will work with others, but not wasm-bindgen. Use trunk or others
#COPY --from=builder /usr/local/cargo/bin/client /usr/local/bin/app
#COPY --from=builder ["/app/index.html", "/app/Cargo.toml", "/app/Cargo.lock", "/app/dist/", "/app/.env", "/app/src/", "."]
#COPY --from=builder /app/src/ ./src/

# change ownership of files to enable rootless exec
#RUN chown -R appuser:appuser /app

# switch to the non-root user
#USER appuser

#EXPOSE 8081
#CMD ["./app"]

