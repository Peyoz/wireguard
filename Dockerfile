FROM golang:1.20 as build
WORKDIR /go/src
RUN git clone https://github.com/kubernetes-sigs/iptables-wrappers.git
WORKDIR /go/src/iptables-wrappers
RUN make build

# Prepare final image, from linuxserver base
FROM linuxserver/wireguard:latest
COPY --from=build /go/src/iptables-wrappers/iptables-wrapper-installer.sh /
COPY --from=build /go/src/iptables-wrappers/bin/iptables-wrapper /
RUN bash /iptables-wrapper-installer.sh
RUN apk add nftables