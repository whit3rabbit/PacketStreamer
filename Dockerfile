FROM golang:latest as builder

RUN apt-get update -y \
    && apt-get install -y \
    flex \
    bison \
    git \
    make
RUN git clone --branch libpcap-1.10.1 --depth 1 https://github.com/the-tcpdump-group/libpcap.git /libpcap \
    && cd /libpcap \
    && ./configure \
    --disable-shared \
    --disable-usb \
    --disable-netmap \
    --disable-bluetooth \
    --disable-dbus \
    --disable-rdma \
    && make -j $(nproc) \
    && make install
COPY . /src
WORKDIR /src
ARG RELEASE=0
RUN go mod tidy
RUN make build STATIC=1 RELEASE=${RELEASE}

FROM alpine:3.15 as packetstreamer

COPY --from=builder /src/packetstreamer /usr/bin/packetstreamer
ENTRYPOINT ["/usr/bin/packetstreamer"]
