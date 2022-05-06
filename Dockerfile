FROM golang:latest as builder

RUN apt-get update -y \
    && apt-get install -y \
    git \
    libpcap-dev \
    make
COPY . /src
WORKDIR /src
ARG RELEASE=0
RUN go mod tidy
RUN make build STATIC=1 RELEASE=${RELEASE}

FROM alpine:3.15 as packetstreamer

COPY --from=builder /src/packetstreamer /usr/bin/packetstreamer
ENTRYPOINT ["/usr/bin/packetstreamer"]
